require 'rails_helper'

RSpec.describe 'Transaction settlement actions', type: :unit do 
  let(:transaction_uid)        { SecureRandom.uuid }
  let(:creditor)              { create(:user) }
  let(:debtor)                { create(:user) }
  let(:zloty)                 { create(:currency) }
  let(:one_instalment)        { create(:settlement_method) }
  let!(:repayment_condition)   { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }

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
    command_bus.call(Transactions::Commands::IssueTransaction.send(@issue_tran_params))
  end

  context 'when on time' do 
    context 'when valid amount'
      it 'settles transaction' do 
        params = {
          transaction_uid: transaction_uid,
          date_of_settlement: Date.today,
          amount: @issue_tran_params[:amount],
          debtor_id: @issue_tran_params[:debtor_id]
        }

        expect {
          command_bus.call(Transactions::Commands::SettleTransaction.send(params))
        }.to change { WriteModels::CredibilityPoint.all.count }.by(1)
         .and change { WriteModels::TrustPoint.all.count }.by(1)
         .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).status }.from('pending').to('closed')
 
        expect(ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).date_of_settlement).to eq(Date.today)
      
        expect(event_store).to have_published(
          an_event(Transactions::Events::TransactionIssued),
          an_event(Transactions::Events::TransactionSettled),
          an_event(Transactions::Events::TransactionClosed)
        ).in_stream("Transaction$#{transaction_uid}").strict

        expect(event_store).to have_published(
          an_event(CredibilityPoints::Events::CredibilityPointsAlloted),
          an_event(TrustPoints::Events::TrustPointsAlloted)
        ).in_stream("TransactionPoint$#{transaction_uid}").strict
      end
    end 
  end