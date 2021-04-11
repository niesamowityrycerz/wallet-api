require 'rails_helper'

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

    @settlement_terms_params = {  
      transaction_uid: transaction_uid,
      debtor_id: debtor.id,
      max_date_of_settlement: Date.today + rand(1..9).day,
      debtor_settlement_method_id: one_instalment.id,
      currency_id: zloty.id 
    }
    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
  end

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
  
    it 'corrects transaction' do
      transaction_p = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)
      before = {
        description: transaction_p.description,
        amount: transaction_p.amount,
        currency_id: transaction_p.currency_id,
        date_of_transaction: transaction_p.date_of_transaction
      }
  
      params = {
        transaction_uid: transaction_uid,
        amount: 111.0
      }
  
      expect {
        command_bus.call(Transactions::Commands::CorrectTransaction.new(params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).amount }.from(before[:amount]).to(params[:amount])
      
      expect {
        command_bus.call(Transactions::Commands::CorrectTransaction.new(params))
      }.not_to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).description }.from(before[:description])

      expect {
        command_bus.call(Transactions::Commands::CorrectTransaction.new(params))
      }.not_to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).date_of_transaction }.from(before[:date_of_transaction])

      expect {
        command_bus.call(Transactions::Commands::CorrectTransaction.new(params))
      }.not_to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).currency_id }.from(before[:currency_id])
      
      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionCorrected)
      ).in_stream("Transaction$#{transaction_uid}")
    end
  end
end 
