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

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
  end

  context 'when debtor has doubts' do 
    context 'when happy path' do 
      it 'checks out debt details' do
        params = {
          debt_uid: debt_uid,
          doubts: 'Amount is incorrect.It Should be less.'
        }
    
        expect {
          command_bus.call(Debts::Commands::CheckOutDebtDetails.new(params))
        }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).doubts }.from(nil).to(params[:doubts]) 
    
        expect(event_store).to have_published(
          an_event(Debts::Events::DebtDetailsCheckedOut)
        ).in_stream("Debt$#{debt_uid}")
      end
    end

    context 'when exceeded characters in doubts column' do 
      it 'raises error' do
        params = {
          debt_uid: debt_uid,
          doubts: 'i'*51
        }

        check_out_debt_details = Debts::Commands::CheckOutDebtDetails.new(params)
        expect {
          command_bus.call(check_out_debt_details)
        }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Doubts 50 characters is maximum!')
      end
    end 
  end 
end 
