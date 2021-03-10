require 'rails_helper'

RSpec.describe 'Transaction flow', type: :unit do 

  let!(:creditor)            { create(:user) }
  let!(:debtor)              { create(:user) }
  let!(:zloty)               { create(:currency) }
  let!(:euro)                { create(:currency, :euro) }
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

    @settlement_terms_params = {  
      transaction_uid: @transaction_uid,
      creditor_id: creditor.id,
      debtor_id: debtor.id,
      max_date_of_settlement: Date.today + rand(1..9).day,
      settlement_method_id: one_instalment.id,
      currency_id: zloty.id 
    }

    issue_transaction = Transactions::Commands::IssueTransaction.send(@issue_tran_params)
    command_bus.call(issue_transaction)

  end

  context 'when happy_path' do 
    it 'issues transaction' do 
      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued)
      ).in_stream("Transaction$#{@transaction_uid}").strict 
    end

    it 'accepts transaction' do 
      accept_transaction = Transactions::Commands::AcceptTransaction.send({transaction_uid: @transaction_uid})
      command_bus.call(accept_transaction)

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionAccepted)
      ).in_stream("Transaction$#{@transaction_uid}").strict 
    end

    it 'adds settlement terms' do
      settlement_terms = Transactions::Commands::AddSettlementTerms.send(@settlement_terms_params)
      command_bus.call(settlement_terms)

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::SettlementTermsAdded)
      ).in_stream("Transaction$#{@transaction_uid}").strict
    end

    it 'rejects transaction' do 
      reject_transaction = Transactions::Commands::RejectTransaction.send({transaction_uid: @transaction_uid})

      expect {
        command_bus.call(reject_transaction)
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).creditor_informed }.from(false).to(true)

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionRejected),
        an_event(Transactions::Events::CreditorInformed)
      ).in_stream("Transaction$#{@transaction_uid}").strict 
    end

    it 'closes transaction' do
      params = {
        transaction_uid: @transaction_uid,
        reason_for_closing: 'Błędna transakcja'
      }

      close_transaction  = Transactions::Commands::CloseTransaction.new(params)
      expect {
        command_bus.call(close_transaction)
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).status }.from('pending').to('closed') 

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionClosed).with_data(reason_for_closing: params[:reason_for_closing])
      ).in_stream("Transaction$#{@transaction_uid}").strict
    end

    it 'checks out transaction' do
      params = {
        transaction_uid: @transaction_uid,
        doubts: 'Amount is incorrect.It Should be less.'
      }

      check_out_transaction = Transactions::Commands::CheckOutTransaction.new(params)
      expect {
        command_bus.call(check_out_transaction)
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).doubts }.from(nil).to(params[:doubts]) 

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionCheckedOut)
      ).in_stream("Transaction$#{@transaction_uid}").strict
    end

    it 'corrects transaction' do 
      transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid)
      before = {
        description: transaction.description,
        amount: transaction.amount,
        currency_id: transaction.currency_id,
        date_of_transaction: transaction.date_of_transaction
      }

      params = {
        transaction_uid: @transaction_uid,
        description: 'zmieniony opis',
        amount: 111.0,
        date_of_transaction: Date.today - rand(1..5).day,
        currency_id: euro.id
      }
      correct_transaction = Transactions::Commands::CorrectTransaction.new(params)
      expect {
        command_bus.call(correct_transaction)
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).description }.from(before[:description]).to(params[:description])
       .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).amount }.from(before[:amount]).to(params[:amount])
       .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).date_of_transaction }.from(before[:date_of_transaction]).to(params[:date_of_transaction])
       .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).currency_id }.from(before[:currency_id]).to(params[:currency_id])
      
      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionCorrected)
      ).in_stream("Transaction$#{@transaction_uid}").strict
    end

    it 'settles transaction' do 
      params = {
        transaction_uid: @transaction_uid,
        date_of_settlement: Date.today,
        amount: @issue_tran_params[:amount],
        debtor_id: @issue_tran_params[:debtor_id]
      }

      settle_transaction = Transactions::Commands::SettleTransaction.new(params)
      expect {
        command_bus.call(settle_transaction)
      }.to change { WriteModels::TransactionPoints::CredibilityPoint.all.count }.by(1)
       .and change { WriteModels::TransactionPoints::FaithPoint.all.count }.by(1)

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionSettled)
      ).in_stream("Transaction$#{@transaction_uid}").strict

      expect(event_store).to have_published(
        an_event(TransactionPoints::Events::CredibilityPointsCalculated),
        an_event(TransactionPoints::Events::FaithPointsCalculated)
      ).in_stream("TransactionPoint$#{@transaction_uid}").strict
    end
  end 
end