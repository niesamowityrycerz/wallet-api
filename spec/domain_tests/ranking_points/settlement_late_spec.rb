require 'rails_helper'

RSpec.describe 'Ranking points flow', type: :unit do
  let(:debt_uid)             { SecureRandom.uuid }
  let(:creditor)             { create(:creditor, :with_ranking_position) }
  let(:debtor)               { create(:debtor, :with_ranking_position) }
  let!(:tran_projection)     { create(:debt_projection, debt_uid: debt_uid, debtor_id: debtor.id) }
  let!(:warning_type)        { create(:warning_type) }
  let(:zloty)                { create(:currency) }
  let(:one_instalment)       { create(:settlement_method) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }


  
  before(:each) do
    @issue_tran_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }

    @settle_params = {
      debt_uid: debt_uid,
      date_of_settlement: Date.today,
      amount: @issue_tran_params[:amount],
      debtor_id: @issue_tran_params[:debtor_id]
    }

    @missed_debt_repayment_params = {
      debt_uid: debt_uid,
      debtor_id: debtor.id
    }

    @debtor_terms = {
      debt_uid: debt_uid,
      anticipated_date_of_settlement: Date.today + rand(1..3),
      debtor_settlement_method_id: one_instalment.id 
    }

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
    command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
    command_bus.call(Debts::Commands::AddDebtorTerms.new(@debtor_terms))
  end

  context 'when debt accepted' do 
    context 'when debtor terms added' do
      context 'when missed debt repayment date' do 
        it 'sends warning and settles debt' do
          expect {
            command_bus.call(Warnings::Commands::SendMissedDebtRepaymentWarning.new(@missed_debt_repayment_params))
          }.to change { ReadModels::Warnings::DebtWarningProjection.count }.by(1)
          .and change { WriteModels::Warning.count }.by(1)
          
          warning_uid = event_store.read.stream("RankingPoint$#{debt_uid}").to_a[-1].data[:warning_uid]
          penalty_points = event_store.read.stream("RankingPoint$#{debt_uid}").to_a[-1].data[:penalty_points]

          expect(ReadModels::Warnings::DebtWarningProjection.find_by!(warning_uid: warning_uid).penalty_points).to eq(penalty_points)
          
          expect {
            command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))
          }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('penalty_points_alloted').to('closed')


          expect(event_store).not_to have_published(
            an_event(Debts::Events::DebtIssued),
            an_event(Debts::Events::DebtAccepted),
            an_event(Debts::Events::DebtorTermsAdded),
            an_event(Warnings::Events::MissedDebtRepaymentWarningSent),
            an_event(Debts::Events::DebtSettled),
            an_event(Debts::Events::DebtClosed)
          ).in_stream("Debt$#{debt_uid}")

          expect(event_store).to have_published(
            an_event(Warnings::Events::MissedDebtRepaymentWarningSent)
          ).in_stream("DebtWarning$#{debt_uid}")

          expect(event_store).to have_published(
            an_event(RankingPoints::Events::PenaltyPointsAdded),
            an_event(RankingPoints::Events::CredibilityPointsAlloted),
            an_event(RankingPoints::Events::TrustPointsAlloted)
          ).in_stream("RankingPoint$#{debt_uid}")
        end
      end
    end
  end
end