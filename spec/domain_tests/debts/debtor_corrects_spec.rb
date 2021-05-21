require 'rails_helper'
require 'shared_examples/debts/correct_debt'

RSpec.describe 'Debts', type: :integration do 

  let(:debt_uid)                { SecureRandom.uuid }
  let(:creditor)                { create(:creditor) }
  let(:debtor)                  { create(:debtor) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }

  before(:each) do 
    @issue_debt_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
    command_bus.call(Debts::Commands::IssueDebt.send(@issue_debt_params))

    @check_out_details_params = {
      debt_uid: debt_uid,
      doubts: 'test'
    }
    command_bus.call(Debts::Commands::CheckOutDebtDetails.send(@check_out_details_params))
  end

  it_should_behave_like 'on correcting debt', attribute = { amount: rand(10.0..1000.0) }
  it_should_behave_like 'on correcting debt', attribute = { description: "Corrected description" }
  it_should_behave_like 'on correcting debt', attribute = { date_of_transaction: Date.today - rand(100..200) }

  context 'when correct currency' do 
    it 'checks currency change' do 
      before = @issue_debt_params[:currency_id]

      params = { 
        debt_uid: debt_uid,
        currency_id: euro.id
      }

      expect {
        command_bus.call(Debts::Commands::CorrectDebtDetails.new(params))
      }.to change { ReadModels::Debts::DebtProjection.first.currency_id }.from(before).to(euro.id)
      
      expect(event_store).to have_published(
        an_event(Debts::Events::DebtDetailsCorrected)
      ).in_stream("Debt$#{debt_uid}")
    end
  end
  
end