require 'rails_helper'
require 'shared_examples/debts/correct_debt'

RSpec.describe 'Debts', type: :integration do 

  let(:debt_uid)                { SecureRandom.uuid }
  let(:creditor)                { create(:creditor) }
  let(:debtor)                  { create(:debtor) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }
  let!(:debt_projection)        { create(:debt_projection, :pending, debt_uid: debt_uid) }


  it_should_behave_like 'on correcting debt', attribute = { amount: rand(10.0..1000.0) }
  it_should_behave_like 'on correcting debt', attribute = { description: "Corrected description" }
  it_should_behave_like 'on correcting debt', attribute = { date_of_transaction: Date.today - rand(100..200) }

  context 'when correct currency' do 
    it 'checks currency change' do 
      debt_p = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
      before = debt_p.currency_id

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