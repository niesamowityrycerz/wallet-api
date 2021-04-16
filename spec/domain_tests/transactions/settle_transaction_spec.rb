require 'rails_helper'

RSpec.describe 'Transaction actions', type: :unit do 
  let(:transaction_uid)        { SecureRandom.uuid }
  let(:creditor)               { create(:creditor, :with_ranking_position) }
  let(:debtor)                 { create(:debtor, :with_ranking_position) }
  let(:zloty)                  { create(:currency) }
  let(:one_instalment)         { create(:settlement_method) }
  let!(:repayment_condition)   { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }

  before(:each) do
    @issue_tran_params = {
      transaction_uid: transaction_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }

    @debtor_terms = {
      transaction_uid: transaction_uid,
      anticipated_date_of_settlement: Date.today + rand(1..3),
      debtor_settlement_method_id: one_instalment.id 
    }

    @settlement_params = {
      transaction_uid: transaction_uid,
      date_of_settlement: Date.today + rand(1..9),
    }

    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
  end


  context 'when settlement on time' do 
    context 'when transaction accepted' do 
      context 'when debtor terms added' do
        it 'settles transaction' do 
          command_bus.call(Transactions::Commands::AcceptTransaction.new({transaction_uid: transaction_uid}))
          command_bus.call(Transactions::Commands::AddDebtorTerms.new(@debtor_terms))
            
          expect {
            command_bus.call(Transactions::Commands::SettleTransaction.new(@settlement_params))
          }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).status }.from('debtors_terms_added').to('closed')
          .and change { WriteModels::DebtorsRanking.find_by!(debtor_id: debtor.id).debt_transactions }.by(1)
          .and change { WriteModels::CreditorsRanking.find_by!(creditor_id: creditor.id).credit_transactions }.by(1)

          expect(ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).date_of_settlement).to eq(Date.today)
        
          expect(event_store).to have_published(
            an_event(Transactions::Events::TransactionIssued),
            an_event(Transactions::Events::TransactionAccepted),
            an_event(Transactions::Events::DebtorTermsAdded),
            an_event(Transactions::Events::TransactionSettled),
            an_event(Transactions::Events::TransactionClosed)
          ).in_stream("Transaction$#{transaction_uid}").strict

          expect(event_store).to have_published(
            an_event(RankingPoints::Events::CredibilityPointsAlloted),
            an_event(RankingPoints::Events::TrustPointsAlloted)
          ).in_stream("RankingPoint$#{transaction_uid}").strict
        end
      end 
    
      context 'when debtor did not specify terms' do
        it 'raises error' do 
          expect {
            command_bus.call(Transactions::Commands::SettleTransaction.new(@settlement_params))
          }.to raise_error(Transactions::TransactionAggregate::DebtorTermsNotAdded)
        end
      end
    end 
  end 
end 