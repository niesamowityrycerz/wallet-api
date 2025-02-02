require 'rails_helper'

RSpec.describe 'Debt actions', type: :unit do 

  let(:debt_uid)              { SecureRandom.uuid }
  let(:creditor)              { create(:user) }
  let(:debtor)                { create(:user) }
  let(:zloty)                 { create(:currency) }
  
  let!(:repayment_condition)  { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty) }

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

    @debtor_terms_params = {  
      debt_uid: debt_uid,
      anticipated_date_of_settlement: Date.today + rand(1..9).day
    }

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
  end

  context 'when debt is issued' do 
    context 'when debt is not accepted' do 
      it 'raises error on attempt' do 
        expect {
          command_bus.call(Debts::Commands::AddAnticipatedSettlementDate.new(@debtor_terms_params))
        }.to raise_error(Debts::DebtAggregate::DebtNotAccepted)
      end
    end 


    context 'when debt is accepted' do 

      before(:each) do 
        command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
      end

      context 'when date exceded maturity' do 
        it 'raises error' do 
          @debtor_terms_params[:anticipated_date_of_settlement] = Date.today + 20.day 
          settlement_terms = Debts::Commands::AddAnticipatedSettlementDate.new(@debtor_terms_params)
          
          expect {
            command_bus.call(settlement_terms)
          }.to raise_error(Debts::DebtAggregate::AnticipatedDateOfSettlementUnavailable)
        end
      end
    
      context 'when debt is accepted' do 
        it 'adds anticipated date of settlement' do 
          expect {
            command_bus.call(Debts::Commands::AddAnticipatedSettlementDate.new(@debtor_terms_params))
          }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).anticipated_date_of_settlement }.from(nil).to(@debtor_terms_params[:anticipated_date_of_settlement])

          expect(event_store).to have_published(
            an_event(Debts::Events::AnticipatedSettlementDateAdded)
          ).in_stream("Debt$#{debt_uid}")
        end
      end
    end 
  end 
end