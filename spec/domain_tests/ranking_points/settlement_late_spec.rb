require 'rails_helper'

RSpec.describe 'Ranking points flow', type: :unit do
  let(:transaction_uid)      { SecureRandom.uuid }
  let(:debtor)               { create(:debtor) }
  let!(:tran_projection)     { create(:transaction_projection, transaction_uid: transaction_uid, debtor_id: debtor.id) }
  let!(:warning_type)        { create(:warning_type) }
  let(:creditor)             { create(:user) }
  let(:zloty)                { create(:currency) }
  let(:one_instalment)       { create(:settlement_method) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }


  
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

  context 'when transaction expired' do 
    it 'sends warning and settles transaction' do
      expect {
        command_bus.call(Warnings::Commands::SendTransactionExpiredWarning.new(@transaction_expired_params))
      }.to change { ReadModels::Warnings::TransactionWarningProjection.count }.by(1)
       .and change { WriteModels::Warning.count }.by(1)
      
      warning_uid = event_store.read.stream("RankingPoint$#{transaction_uid}").to_a[-1].data[:warning_uid]
      penalty_points = event_store.read.stream("RankingPoint$#{transaction_uid}").to_a[-1].data[:penalty_points]

      expect(ReadModels::Warnings::TransactionWarningProjection.find_by!(warning_uid: warning_uid).penalty_points).to eq(penalty_points)
      
      expect {
        command_bus.call(Transactions::Commands::SettleTransaction.new(@settle_params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).status }.from('penalty_points_alloted').to('closed')


      expect(event_store).not_to have_published(
        an_event(Warnings::Events::TransactionExpiredWarningSent),
        an_event(Transactions::Events::TransactionSettled),
        an_event(Transactions::Events::TransactionClosed)
      ).in_stream("Transaction$#{transaction_uid}")

      expect(event_store).to have_published(
        an_event(Warnings::Events::TransactionExpiredWarningSent)
      ).in_stream("TransactionWarning$#{transaction_uid}")

      expect(event_store).to have_published(
        an_event(RankingPoints::Events::PenaltyPointsAdded),
        an_event(RankingPoints::Events::CredibilityPointsAlloted),
        an_event(RankingPoints::Events::TrustPointsAlloted)
      ).in_stream("RankingPoint$#{transaction_uid}")
    end
  end
end