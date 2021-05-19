require 'rails_helper'

RSpec.describe 'Ranking points', type: :unit do
  let(:debt_uid)             { SecureRandom.uuid }
  let(:creditor)             { create(:creditor) }
  let(:debtor)               { create(:debtor, :with_some_ranking_data) }
  let!(:warning_type)        { create(:warning_type) }
  let(:zloty)                { create(:currency) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }


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

    @anticipated_date_of_settlement_params = {
      debt_uid: debt_uid,
      anticipated_date_of_settlement: Date.today + rand(1..3),
    }

    @missed_debt_repayment_params = {
      debt_uid: debt_uid,
      debtor_id: debtor.id
    }

    command_bus.call(Debts::Commands::IssueDebt.send(@issue_tran_params))
    command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
    command_bus.call(Debts::Commands::AddAnticipatedSettlementDate.send(@anticipated_date_of_settlement_params))
  end

  context 'when happy path' do 
    context 'when missed debt repayment date' do 
      it 'sends warning and check added penalty points' do
        expect {
          command_bus.call(Warnings::Commands::SendMissedDebtRepaymentWarning.send(@missed_debt_repayment_params))
        }.to change { ReadModels::Warnings::DebtWarningProjection.count }.by(1)
        .and change { WriteModels::Warning.count }.by(1)
        
        warning_uid = event_store.read.stream("RankingPoint$#{debt_uid}").to_a[-1].data[:warning_uid]
        penalty_points = event_store.read.stream("RankingPoint$#{debt_uid}").to_a[-1].data[:penalty_points]

        expect(ReadModels::Warnings::DebtWarningProjection.find_by!(warning_uid: warning_uid).penalty_points).to eq(penalty_points)
        
        expect(event_store).to have_published(
          an_event(Warnings::Events::MissedDebtRepaymentWarningSent)
        ).in_stream("DebtWarning$#{debt_uid}")

        expect(event_store).to have_published(
          an_event(RankingPoints::Events::PenaltyPointsAdded),
        ).in_stream("RankingPoint$#{debt_uid}")
      end
    end
  end
end