require 'rails_helper'

RSpec.describe 'Debtor adds settlement terms', type: :unit do 

  let(:transaction_uid)        { SecureRandom.uuid }
  let!(:creditor)              { create(:user) }
  let!(:debtor)                { create(:user) }
  let!(:zloty)                 { create(:currency) }
  let!(:euro)                  { create(:currency, :euro) }
  let!(:one_instalment)        { create(:settlement_method) }
  let!(:repayment_condition)   { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }

  # REPAYMENT CONDITION READ MODEL WYCIAGANY Z EVENT STREAMU 
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
      settlement_method_id: one_instalment.id,
      currency_id: zloty.id 
    }

    command_bus.call(Transactions::Commands::IssueTransaction.send(@issue_tran_params))
  end

  context 'when acceptable' do 
    it 'adds debtor settlement terms' do 
      command_bus.call(Transactions::Commands::AddSettlementTerms.send(@settlement_terms_params))
    end
  end
end