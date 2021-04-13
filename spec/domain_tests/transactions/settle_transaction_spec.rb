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
    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
  end

  context 'when settlement on time' do 
    context 'when valid amount'
      it 'settles transaction' do 
        params = {
          transaction_uid: transaction_uid,
          date_of_settlement: Date.today,
        }
          
        expect {
          command_bus.call(Transactions::Commands::SettleTransaction.new(params))
        }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).status }.from('pending').to('closed')
         .and change { WriteModels::DebtorsRanking.find_by!(debtor_id: debtor.id).debt_transactions }.by(1)
         .and change { WriteModels::CreditorsRanking.find_by!(creditor_id: creditor.id).credit_transactions }.by(1)

        expect(ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).date_of_settlement).to eq(Date.today)
      
        expect(event_store).to have_published(
          an_event(Transactions::Events::TransactionIssued),
          an_event(Transactions::Events::TransactionSettled),
          an_event(Transactions::Events::TransactionClosed)
        ).in_stream("Transaction$#{transaction_uid}").strict

        expect(event_store).to have_published(
          an_event(RankingPoints::Events::CredibilityPointsAlloted),
          an_event(RankingPoints::Events::TrustPointsAlloted)
        ).in_stream("RankingPoint$#{transaction_uid}").strict
      end
    end 
  end