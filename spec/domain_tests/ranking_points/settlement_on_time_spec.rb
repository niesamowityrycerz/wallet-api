require 'rails_helper'

RSpec.describe 'Ranking Points flow ', type: :unit do 

  let(:debt_uid)             { SecureRandom.uuid }
  let(:creditor)             { create(:creditor, :with_ranking_position) }
  let(:debtor)               { create(:debtor, :with_ranking_position) }
  let(:zloty)                { create(:currency) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }
  let!(:warning_type)        { create(:warning_type) }

  
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

    @debtor_terms = {
      debt_uid: debt_uid,
      anticipated_date_of_settlement: Date.today + rand(1..3),
    }


    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
    command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
    command_bus.call(Debts::Commands::AddDebtorTerms.new(@debtor_terms))
  end

  context 'when debt accepted' do 
    context 'when debtor terms added' do
      context 'when debt pending' do 
        it 'it settles debt and checks points' do 
          expect {
            command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))
          }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).date_of_settlement }.from(nil).to(Date.today)

          ranking_points = event_store.read.stream("RankingPoint$#{debt_uid}").to_a

          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)

          cred_points  = event_store.read.stream("RankingPoint$#{debt_uid}").to_a.first.data[:credibility_points]
          trust_points = event_store.read.stream("RankingPoint$#{debt_uid}").to_a.second.data[:trust_points]

          expect(debt_projection.credibility_points).to eq(cred_points)
          expect(debt_projection.adjusted_credibility_points).to eq(cred_points)
          expect(debt_projection.trust_points).to eq(trust_points)

          expect(event_store).to have_published(
            an_event(Debts::Events::DebtIssued),
            an_event(Debts::Events::DebtAccepted),
            an_event(Debts::Events::DebtorTermsAdded),
            an_event(Debts::Events::DebtSettled),
            an_event(Debts::Events::DebtClosed)
          ).in_stream("Debt$#{debt_uid}")
          
          expect(event_store).to have_published(
            an_event(RankingPoints::Events::TrustPointsAlloted),
            an_event(RankingPoints::Events::CredibilityPointsAlloted)
          ).in_stream("RankingPoint$#{debt_uid}")
        end
      end
    end
  end
end 
