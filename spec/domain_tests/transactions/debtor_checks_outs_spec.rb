require 'rails_helper'
require 'shared_examples/transactions/correct_transaction'


RSpec.describe 'Transaction actions', type: :unit do 
  
  let(:transaction_uid)         { SecureRandom.uuid }
  let(:creditor)                { create(:user) }
  let(:debtor)                  { create(:user) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
  let(:one_instalment)          { create(:settlement_method) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }
  let!(:transaction_projection) { create(:transaction_projection, :pending, transaction_uid: transaction_uid) }

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

    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
  end

  it_should_behave_like 'on correcting transaction', attribute = { amount: 111.0 }
  it_should_behave_like 'on correcting transaction', attribute = { description: "Corrected description" }
  it_should_behave_like 'on correcting transaction', attribute = { currency_id: (Currency.ids.select { |id| id != zloty.id }).sample }
  it_should_behave_like 'on correcting transaction', attribute = { date_of_transaction: Date.today - rand(100..200) }


  context 'when debtor has doubts' do 
    it 'checks out transaction' do
      params = {
        transaction_uid: transaction_uid,
        doubts: 'Amount is incorrect.It Should be less.'
      }
  
      expect {
        command_bus.call(Transactions::Commands::CheckOutTransaction.new(params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).doubts }.from(nil).to(params[:doubts]) 
  
      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionCheckedOut)
      ).in_stream("Transaction$#{transaction_uid}")
    end

    context 'when exceeded characters in doubts column' do 
      it 'raises error' do
        params = {
          transaction_uid: transaction_uid,
          doubts: 'i'*51
        }

        check_out_transaction = Transactions::Commands::CheckOutTransaction.new(params)
        expect {
          command_bus.call(check_out_transaction)
        }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Doubts 50 characters is maximum!')
      end
    end 
  end 

end 
