require 'rails_helper'

RSpec.describe 'Transaction actions when exceptions', type: :unit do 

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

    @settlement_terms_params = {  
      transaction_uid: @transaction_uid,
      creditor_id: creditor.id,
      debtor_id: debtor.id,
      max_date_of_settlement: Date.today + rand(1..10).day,
      debtor_settlement_method_id: one_instalment.id,
      currency_id: zloty.id 
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

  context 'when debtor adds unsupported settlement terms' do 
    context 'when currency is invalid' do 
      it 'attempt to adds settlement terms' do
        issue_transaction = Transactions::Commands::IssueTransaction.new(@issue_tran_params)
        command_bus.call(issue_transaction)

        @settlement_terms_params[:currency_id] = euro.id
        settlement_terms = Transactions::Commands::AddSettlementTerms.new(@settlement_terms_params)

        expect {
          command_bus.call(settlement_terms)
        }.to raise_error(Transactions::TransactionAggregate::CurrencyUnavaiable)
      end
    end 

    context 'when settlement method is invalid' do 
      it 'attempts to adds settlement terms' do
        issue_transaction = Transactions::Commands::IssueTransaction.new(@issue_tran_params)
        command_bus.call(issue_transaction)

        @settlement_terms_params[:debtor_settlement_method_id] = many_installments.id
        settlement_terms = Transactions::Commands::AddSettlementTerms.new(@settlement_terms_params)
        
        expect {
          command_bus.call(settlement_terms)
        }.to raise_error(Transactions::TransactionAggregate::RepaymentTypeUnavaiable)
      end
    end

    context 'when exceded maturity' do 
      it 'attempt to add settlement terms' do 
        issue_transaction = Transactions::Commands::IssueTransaction.new(@issue_tran_params)
        command_bus.call(issue_transaction)

        @settlement_terms_params[:max_date_of_settlement] = Date.today + 20.day 
        settlement_terms = Transactions::Commands::AddSettlementTerms.new(@settlement_terms_params)
        
        expect {
          command_bus.call(settlement_terms)
        }.to raise_error(Transactions::TransactionAggregate::MaximumDateOfTransactionSettlementUnavailable)
      end
    end
  end

  context 'when exceeded characters in doubts column' do 
    it 'checks out transaction ' do
      issue_transaction  = Transactions::Commands::IssueTransaction.new(@issue_tran_params)
      command_bus.call(issue_transaction)

      params = {
        transaction_uid: @transaction_uid,
        doubts: 'i'*51
      }

      check_out_transaction = Transactions::Commands::CheckOutTransaction.new(params)
      expect {
        command_bus.call(check_out_transaction)
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Doubts 50 characters is maximum!')
    end
  end 
end