require 'rails_helper'

RSpec.describe 'Ranking Points flow ', type: :unit do 

  let(:transaction_uid)      { SecureRandom.uuid }
  let(:creditor)             { create(:user) }
  let(:debtor)               { create(:user) }
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
  end

  context 'when settles transaction' do
    context 'when transaction pending' do 
      it 'checks rankings points' do 
        command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
        expect {
          command_bus.call(Transactions::Commands::SettleTransaction.new(@settle_params))
        }.to change { WriteModels::CredibilityPoints::CredibilityPoint.count }.by(1)
        .and change { WriteModels::TrustPoints::TrustPoint.count }.by(1)

        cred_points  = event_store.read.stream("CredibilityPoint$#{transaction_uid}").to_a
        trust_points = event_store.read.stream("TrustPoint$#{transaction_uid}").to_a

        transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)
        expect(transaction_projection.credibility_points).to eq(cred_points[0].data[:credibility_points])
        expect(transaction_projection.adjusted_credibility_points).to eq(cred_points[1].data[:adjusted_credibility_points])
        expect(transaction_projection.trust_points).to eq(trust_points[0].data[:trust_points])

        expect(event_store).to have_published(
          an_event(Transactions::Events::TransactionIssued),
          an_event(Transactions::Events::TransactionSettled),
          an_event(Transactions::Events::TransactionClosed)
        ).in_stream("Transaction$#{transaction_uid}").strict
        
        expect(event_store).to have_published(
          an_event(CredibilityPoints::Events::CredibilityPointsCalculated),
          an_event(CredibilityPoints::Events::CredibilityPointsAlloted)
        ).in_stream("CredibilityPoint$#{transaction_uid}").strict

        expect(event_store).to have_published(
          an_event(TrustPoints::Events::TrustPointsCalculated),
          an_event(TrustPoints::Events::TrustPointsAlloted)
        ).in_stream("TrustPoint$#{transaction_uid}").strict

        expect(event_store).to have_published(
          an_event(TrustPoints::Events::TrustPointsAlloted),
          an_event(CredibilityPoints::Events::CredibilityPointsAlloted)
        ).in_stream("TransactionPoint$#{transaction_uid}")
      end
    end 

    context 'when transaction expired' do
      it 'checks ranking points on first warning' do
        # poprawić linkowanie eventow
        command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
        binding.pry 
        command_bus.call(Warnings::Commands::SendTransactionExpiredWarning.new(@transaction_expired_params))
        binding.pry
        command_bus.call(Transactions::Commands::SettleTransaction.new(@settle_params))

        binding.pry 
        expect(event_store).to have_published(
          an_event(Transactions::Events::TransactionIssued),
          an_event(Warnings::Events::TransactionExpiredWarningSent),
          an_event(Transactions::Events::TransactionSettled),
          an_event(Transactions::Events::TransactionClosed)
        ).in_stream("Transaction$#{transaction_uid}").strict


      end
    end

  end 
end 
