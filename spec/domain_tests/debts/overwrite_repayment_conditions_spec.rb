require 'rails_helper'

RSpec.describe 'Overwrite basic repayment conditions', type: :integration do
  
  let(:debt_uid)                  { SecureRandom.uuid }
  let(:creditor)                  { create(:user, :with_repayment_conditions) }
  let(:debtor)                    { create(:debtor) }
  let(:zloty)                     { create(:currency) }
  let(:euro)                      { create(:currency, :euro) }

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

    @new_repayment_conditions = {
      debt_uid: debt_uid,
      currency_id: euro.id,
      maturity_in_days: 10
    }
  end

  context 'when debt status == :pending and basic repayment conditions set' do 
    it 'overwrite basic conditions' do 
      debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
      conditions_before = {
        currency_id: debt.currency_id,
        max_date_of_settlement: debt.max_date_of_settlement
      }

      expect {
        command_bus.call(Debts::Commands::OverwriteRepaymentConditions.send(@new_repayment_conditions))
      }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).currency_id }.from(conditions_before[:currency_id]).to(euro.id)
        .and change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).max_date_of_settlement }.from(conditions_before[:max_date_of_settlement]).to(Date.today + 10)

      expect(event_store).to have_published(
        an_event(Debts::Events::RepaymentConditionsOverwrote)
      ).in_stream("Debt$#{debt_uid}")
    end
  end

  context 'when debt status != :pending' do 
    
    before(:each) do 
      command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
    end

    it 'raises error' do 
      expect {
        command_bus.call(Debts::Commands::OverwriteRepaymentConditions.send(@new_repayment_conditions))
      }.to raise_error(Debts::DebtAggregate::UnableToOverwroteRepaymentConditions)
    end
  end
end