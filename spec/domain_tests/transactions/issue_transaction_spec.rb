require 'rails_helper'

RSpec.describe 'Transaction actions', type: :unit do 

  let!(:creditor)            { create(:user) }
  let!(:debtor)              { create(:user) }
  let!(:zloty)               { create(:currency) }
  let!(:euro)                { create(:currency, :euro) }
  let!(:one_instalment)      { create(:settlement_method) }
  let!(:many_installments)   { create(:settlement_method, :multiple_instalments) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }

  before(:all) do 
    @transaction_uid = SecureRandom.uuid
  end

  before(:each) do
    @issue_tran_params = {
      transaction_uid: @transaction_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
  end


  context 'when creditor does not have repayment conditions' do 
    it 'attempts to issue transaction' do
      @issue_tran_params[:creditor_id], @issue_tran_params[:debtor_id] = @issue_tran_params[:debtor_id], @issue_tran_params[:creditor_id]
      issue_transaction = Transactions::Commands::IssueTransaction.new(@issue_tran_params)
      expect {
        command_bus.call(issue_transaction)
      }.to raise_error(Transactions::Repositories::RepaymentCondition::RepaymentConditionsDoNotExist)
    end
  end 

  

  
end