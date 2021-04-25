require 'rails_helper'

RSpec.describe 'Transaction actions', type: :unit do 

  let(:transaction_uid)           { SecureRandom.uuid }
  let(:creditor)                  { create(:user) }
  let(:creditor_with_repay_cond)  { create(:user) }
  let(:debtor)                    { create(:user) }
  let(:zloty)                     { create(:currency) }
  let(:one_instalment)            { create(:settlement_method) }
  let(:many_installments)         { create(:settlement_method, :multiple_instalments) }
  let!(:repayment_condition)      { create(:repayment_condition, :maturity_in_10_days, creditor: creditor_with_repay_cond, currency: zloty, settlement_method: one_instalment) }

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
  end


  context 'when creditor does not have repayment conditions' do 
    it 'raises error on attempt to issue transaction' do
      issue_transaction = Transactions::Commands::IssueTransaction.new(@issue_tran_params)
      expect {
        command_bus.call(issue_transaction)
      }.to raise_error(Transactions::Repositories::RepaymentCondition::RepaymentConditionsDoNotExist)
    end
  end 

  context 'when creditor has repayment conditions' do 
    it 'issues transaction' do 
      @issue_tran_params[:creditor_id] = creditor_with_repay_cond.id
      expect {
        command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
      }.to change { ReadModels::Transactions::TransactionProjection.count }.by(1)
        .and change { WriteModels::FinancialTransaction.count }.from(0).to(1)
        
      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued)
      ).in_stream("Transaction$#{transaction_uid}").strict 
    end
  end

  

  
end