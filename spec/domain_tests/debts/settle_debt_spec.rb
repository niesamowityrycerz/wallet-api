require 'rails_helper'

RSpec.describe 'Debts:', type: :integration do 
  let(:debt_uid)               { SecureRandom.uuid }
  let(:creditor)               { create(:creditor) }
  let(:debtor)                 { create(:debtor) }
  let(:zloty)                  { create(:currency) }
  let!(:repayment_condition)   { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }

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

    @debtor_terms = {
      debt_uid: debt_uid,
      anticipated_date_of_settlement: Date.today + rand(1..3)
    }

    @settlement_params = {
      debt_uid: debt_uid,
      date_of_settlement: Date.today + rand(1..9),
    }

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
  end


  context 'when debt accepted' do 
    context 'when anticipated date added'do 
      context 'when settlement on time' do
        it 'performs happy path' do 
          command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
          command_bus.call(Debts::Commands::AddAnticipatedSettlementDate.new(@debtor_terms))
            
          expect {
            command_bus.call(Debts::Commands::SettleDebt.new(@settlement_params))
          }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('anticipated_settlement_date_added').to('closed')

          expect(ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).date_of_settlement).to eq(Date.today)
        
          expect(event_store).to have_published(
            an_event(Debts::Events::DebtIssued),
            an_event(Debts::Events::DebtAccepted),
            an_event(Debts::Events::AnticipatedSettlementDateAdded),
            an_event(Debts::Events::DebtSettled),
            an_event(Debts::Events::DebtClosed)
          ).in_stream("Debt$#{debt_uid}").strict
        end
      end 
    
      context 'when debtor did not add anticipated date' do
        it 'raises error' do 
          expect {
            command_bus.call(Debts::Commands::SettleDebt.new(@settlement_params))
          }.to raise_error(Debts::DebtAggregate::UnableToProceedSettleement)
        end
      end
    end 
  end 
end 