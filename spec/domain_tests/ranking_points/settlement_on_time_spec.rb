require 'rails_helper'

RSpec.describe 'Ranking Points flow ', type: :unit do 

  let(:transaction_uid)      { SecureRandom.uuid }
  let(:creditor)             { create(:creditor, :with_ranking_position) }
  let(:debtor)               { create(:debtor, :with_ranking_position) }
  let(:zloty)                { create(:currency) }
  let(:one_instalment)       { create(:settlement_method) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }
  let!(:warning_type)        { create(:warning_type) }

  
  before(:each) do
    @issue_tran_params = {
      transaction_uid: transaction_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }

    @settle_params = {
      transaction_uid: transaction_uid,
      date_of_settlement: Date.today,
      amount: @issue_tran_params[:amount],
      debtor_id: @issue_tran_params[:debtor_id]
    }

    @transaction_expired_params = {
      transaction_uid: transaction_uid,
      debtor_id: debtor.id
    }

    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
  end

  context 'when transaction pending' do 
    it 'it settles transaction and checks points' do 
      expect {
        command_bus.call(Transactions::Commands::SettleTransaction.new(@settle_params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).date_of_settlement }.from(nil).to(Date.today)

      ranking_points = event_store.read.stream("RankingPoint$#{transaction_uid}").to_a

      transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)

      cred_points  = event_store.read.stream("RankingPoint$#{transaction_uid}").to_a.first.data[:credibility_points]
      trust_points = event_store.read.stream("RankingPoint$#{transaction_uid}").to_a.second.data[:trust_points]

      expect(transaction_projection.credibility_points).to eq(cred_points)
      expect(transaction_projection.adjusted_credibility_points).to eq(cred_points)
      expect(transaction_projection.trust_points).to eq(trust_points)

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionSettled),
        an_event(Transactions::Events::TransactionClosed)
      ).in_stream("Transaction$#{transaction_uid}").strict
      
      expect(event_store).to have_published(
        an_event(RankingPoints::Events::TrustPointsAlloted),
        an_event(RankingPoints::Events::CredibilityPointsAlloted)
      ).in_stream("RankingPoint$#{transaction_uid}")
    end
  end 
end 
