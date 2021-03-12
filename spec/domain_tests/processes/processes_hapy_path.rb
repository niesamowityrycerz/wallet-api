require 'rails_helper'

RSpec.describe 'RankingPoint Processes manager', type: :unit do 

  let!(:creditor)            { create(:user) }
  let!(:debtor)              { create(:user) }
  let!(:zloty)               { create(:currency) }
  let!(:one_instalment)      { create(:settlement_method) }
  let!(:repayment_condition) { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }



  before(:each) do
    @transaction_uid = SecureRandom.uuid
    @issue_tran_params = {
      transaction_uid: @transaction_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }

    issue_transaction = Transactions::Commands::IssueTransaction.send(@issue_tran_params)
    command_bus.call(issue_transaction)

  end

  context 'when settles transaction' do 
    it 'calculates credibility and trust points and then allot them' do 
      params = {
        transaction_uid: @transaction_uid,
        date_of_settlement: Date.today,
        amount: @issue_tran_params[:amount],
        debtor_id: @issue_tran_params[:debtor_id]
      }
  
      settle_transaction = Transactions::Commands::SettleTransaction.new(params)
      expect {
        command_bus.call(settle_transaction)
      }.to change { WriteModels::CredibilityPoints::CredibilityPoint.all.count }.by(1)
       .and change { WriteModels::TrustPoints::TrustPoint.all.count }.by(1)

       #WriteModels::CredibilityPoints::CredibilityPoint.all.count
       #WriteModels::TrustPoints::TrustPoint.all.count
       #ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).credibility_points

      #command_bus.call(settle_transaction)
      binding.pry
  
      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionSettled)
      ).in_stream("Transaction$#{@transaction_uid}").strict
  
      expect(event_store).to have_published(
        an_event(CredibilityPoints::Events::CredibilityPointsCalculated),
        an_event(CredibilityPoints::Events::CredibilityPointsAlloted)
      ).in_stream("RankingCredibilityPoints$#{@transaction_uid}").strict
                  

      expect(event_store).to have_published(
        an_event(TrustPoints::Events::TrustPointsCalculated),
        an_event(TrustPoints::Events::TrustPointsAlloted)
      ).in_stream("RankingTrustPoints$#{@transaction_uid}").strict

    end
  end

  context 'when adds settlement terms' do 
    it 'checks flow' do 
      params = {
        transaction_uid: @transaction_uid,
        creditor_id: 1,
        debtor_id: 2,
        max_date_of_settlement: Date,
        settlement_method_id: Integer,
        currency_id: Integer
      }
      add_settlement_terms = Transaction::Commands::AddSettlementTerms

    end
  end
end