require 'rails_helper'

RSpec.describe 'Debt actions', type: :unit do 

  let(:debt_uid)                  { SecureRandom.uuid }
  let(:creditor)                  { create(:user) }
  let(:creditor_with_repay_cond)  { create(:user) }
  let(:debtor)                    { create(:user) }
  let(:zloty)                     { create(:currency) }
  let!(:repayment_condition)      { create(:repayment_condition, :maturity_in_10_days, creditor: creditor_with_repay_cond, currency: zloty) }

  before(:each) do
    @issue_tran_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
  end


  context 'when creditor does not have repayment conditions' do 
    it 'raises error on attempt to issue debt' do
      issue_debt = Debts::Commands::IssueDebt.new(@issue_tran_params)
      expect {
        command_bus.call(issue_debt)
      }.to raise_error(Debts::Repositories::RepaymentCondition::RepaymentConditionsDoNotExist)
    end
  end 

  context 'when creditor has repayment conditions' do 
    it 'issues debt' do 
      @issue_tran_params[:creditor_id] = creditor_with_repay_cond.id
      expect {
        command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
      }.to change { ReadModels::Debts::DebtProjection.count }.by(1)
        .and change { WriteModels::Debt.count }.from(0).to(1)
        
      expect(event_store).to have_published(
        an_event(Debts::Events::DebtIssued)
      ).in_stream("Debt$#{debt_uid}").strict 
    end
  end

  

  
end