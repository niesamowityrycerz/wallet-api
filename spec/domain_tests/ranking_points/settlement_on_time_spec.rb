require 'rails_helper'

RSpec.describe 'Ranking Points flow ', type: :unit do 

  let(:debt_uid)             { SecureRandom.uuid }
  let(:creditor)             { create(:creditor, :with_some_ranking_data) }
  let(:debtor)               { create(:debtor, :with_some_ranking_data) }
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

    @anticipated_settlemend_date_params = {
      debt_uid: debt_uid,
      anticipated_date_of_settlement: Date.today + rand(1..3),
    }

    @settle_params = {
      debt_uid: debt_uid,
      date_of_settlement: Date.today,
      amount: @issue_tran_params[:amount],
      debtor_id: @issue_tran_params[:debtor_id]
    }

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
    command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
    command_bus.call(Debts::Commands::AddAnticipatedSettlementDate.new(@anticipated_settlemend_date_params))
  end

  context 'when happy path' do 
    it 'it settles debt and checks updated points' do 
      expect {
        command_bus.call(Debts::Commands::SettleDebt.new(@settle_params))
      }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).date_of_settlement }.from(nil).to(Date.today)

      cred_points  = event_store.read.stream("RankingPoint$#{debt_uid}").to_a.first.data[:credibility_points]
      trust_points = event_store.read.stream("RankingPoint$#{debt_uid}").to_a.second.data[:trust_points]

      debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)

      expect(debt_projection.credibility_points).to eq(cred_points)
      expect(debt_projection.adjusted_credibility_points).to eq(cred_points)
      expect(debt_projection.trust_points).to eq(trust_points)

      expect(event_store).to have_published(
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
