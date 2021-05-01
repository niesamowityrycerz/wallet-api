require 'rails_helper'

RSpec.describe 'Debt actions', type: :unit do 
  let(:debt_uid)               { SecureRandom.uuid }
  let(:creditor)               { create(:creditor, :with_ranking_position) }
  let(:debtor)                 { create(:debtor, :with_ranking_position) }
  let(:zloty)                  { create(:currency) }
  let(:one_instalment)         { create(:settlement_method) }
  let!(:repayment_condition)   { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }

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
      anticipated_date_of_settlement: Date.today + rand(1..3),
      debtor_settlement_method_id: one_instalment.id 
    }

    @settlement_params = {
      debt_uid: debt_uid,
      date_of_settlement: Date.today + rand(1..9),
    }

    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
  end


  context 'when settle on time' do 
    context 'when debt accepted' do 
      context 'when debtor terms added' do
        it 'settles debt' do 
          command_bus.call(Debts::Commands::AcceptDebt.new({debt_uid: debt_uid}))
          command_bus.call(Debts::Commands::AddDebtorTerms.new(@debtor_terms))
            
          expect {
            command_bus.call(Debts::Commands::SettleDebt.new(@settlement_params))
          }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('debtors_terms_added').to('closed')
          .and change { WriteModels::DebtorsRanking.find_by!(debtor_id: debtor.id).debts_quantity }.by(1)
          .and change { WriteModels::CreditorsRanking.find_by!(creditor_id: creditor.id).credits_quantity }.by(1)

          expect(ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).date_of_settlement).to eq(Date.today)
        
          expect(event_store).to have_published(
            an_event(Debts::Events::DebtIssued),
            an_event(Debts::Events::DebtAccepted),
            an_event(Debts::Events::DebtorTermsAdded),
            an_event(Debts::Events::DebtSettled),
            an_event(Debts::Events::DebtClosed)
          ).in_stream("Debt$#{debt_uid}").strict

          expect(event_store).to have_published(
            an_event(RankingPoints::Events::CredibilityPointsAlloted),
            an_event(RankingPoints::Events::TrustPointsAlloted)
          ).in_stream("RankingPoint$#{debt_uid}").strict
        end
      end 
    
      context 'when debtor did not specify terms' do
        it 'raises error' do 
          expect {
            command_bus.call(Debts::Commands::SettleDebt.new(@settlement_params))
          }.to raise_error(Debts::DebtAggregate::DebtorTermsNotAdded)
        end
      end
    end 
  end 
end 