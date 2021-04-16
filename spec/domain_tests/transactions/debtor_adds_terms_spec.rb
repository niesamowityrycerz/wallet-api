require 'rails_helper'

RSpec.describe 'Transaction actions', type: :unit do 

  let(:transaction_uid)        { SecureRandom.uuid }
  let!(:creditor)              { create(:user) }
  let!(:debtor)                { create(:user) }
  let!(:zloty)                 { create(:currency) }
  let!(:euro)                  { create(:currency, :euro) }
  let!(:one_instalment)        { create(:settlement_method) }
  let(:many_installments)      { create(:settlement_method, :multiple_instalments) }
  
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

    @debtor_terms_params = {  
      transaction_uid: transaction_uid,
      anticipated_date_of_settlement: Date.today + rand(1..9).day,
      debtor_settlement_method_id: one_instalment.id,
    }

    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
  end

  context 'when transaction issued' do 
    context 'when transaction not accepted' do 
      it 'raises error' do 
        expect {
          command_bus.call(Transactions::Commands::AddDebtorTerms.new(@debtor_terms_params))
        }.to raise_error(Transactions::TransactionAggregate::TransactionNotAccepted)
      end
    end 


    context 'when transaction accepted' do 

      before(:each) do 
        command_bus.call(Transactions::Commands::AcceptTransaction.new({transaction_uid: transaction_uid}))
      end

      context 'when settlement method is invalid' do 
        it 'raises error' do
          @debtor_terms_params[:debtor_settlement_method_id] = many_installments.id
          settlement_terms = Transactions::Commands::AddDebtorTerms.new(@debtor_terms_params)
          
          expect {
            command_bus.call(settlement_terms)
          }.to raise_error(Transactions::TransactionAggregate::RepaymentTypeUnavaiable)
        end
      end

      context 'when exceded maturity' do 
        it 'raises error' do 
          @debtor_terms_params[:anticipated_date_of_settlement] = Date.today + 20.day 
          settlement_terms = Transactions::Commands::AddDebtorTerms.new(@debtor_terms_params)
          
          expect {
            command_bus.call(settlement_terms)
          }.to raise_error(Transactions::TransactionAggregate::AnticipatedDateOfSettlementUnavailable)
        end
      end
    end
  end 
end