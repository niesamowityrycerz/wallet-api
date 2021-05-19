require 'rails_helper'

RSpec.describe 'Debts', type: :integration do 
  
  let(:debt_uid)                { SecureRandom.uuid }
  let(:creditor)                { create(:creditor) }
  let(:debtor)                  { create(:debtor) }
  let(:zloty)                   { create(:currency) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }

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
    command_bus.call(Debts::Commands::IssueDebt.send(@issue_tran_params))
  end

  context 'when debt is issued' do 
    it 'closes debt' do
      params = {
        debt_uid: debt_uid,
        reason_for_closing: 'wrong debtor'
      }

      expect {
        command_bus.call(Debts::Commands::CloseDebt.send(params))
      }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('pending').to('closed') 

      expect(event_store).to have_published(
        an_event(Debts::Events::DebtClosed).with_data(reason_for_closing: params[:reason_for_closing])
      ).in_stream("Debt$#{debt_uid}")
    end
  end 
end 
