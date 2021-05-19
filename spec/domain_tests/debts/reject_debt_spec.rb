require 'rails_helper'

RSpec.describe 'Debts', type: :integration do 
  
  let(:debt_uid)                { SecureRandom.uuid }
  let(:creditor)                { create(:creditor) }
  let(:debtor)                  { create(:debtor) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
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
    it 'rejects debt' do
      params = {
        debt_uid: debt_uid,
        reason_for_rejection: 'I do not know u!'
      }

      expect {
        command_bus.call(Debts::Commands::RejectDebt.send(params))
      }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).reason_for_rejection }.from(nil).to(params[:reason_for_rejection])
        .and change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('pending').to('rejected')

      expect(event_store).to have_published(
        an_event(Debts::Events::DebtRejected)
      ).in_stream("Debt$#{debt_uid}")
    end
  end 
end