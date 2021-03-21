require 'rails_helper'

RSpec.describe 'Transaction flow', type: :unit do 

  let(:creditor)            { create(:user) }
  let(:debtor)              { create(:user) }
  let(:zloty)               { create(:currency) }
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

    @reject_params = {
      transaction_uid: @transaction_uid,
      reason_for_closing: 'hwdp'
    }
  end


  context 'when reject transaction' do 
    it 'creditor informs admin' do
      expect {
        command_bus.call(Transactions::Commands::RejectTransaction.new(@reject_params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).creditor_informed }.from(false).to(true)
        .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).status }.from('pending').to('rejected')


      inform_admin_params = {
        transaction_uid: @transaction_uid,
        message_to_admin: 'tym nie spłaca'
      }

      expect { 
        command_bus.call(Transactions::Commands::InformAdmin.new(inform_admin_params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).admin_informed }.from(false).to(true) 

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionRejected),
        an_event(Transactions::Events::CreditorInformed),
        an_event(Transactions::Events::AdminInformed).with_data(message_to_admin: inform_admin_params[:message_to_admin])
      ).in_stream("Transaction$#{@transaction_uid}").strict 
    end

    it 'creditor closes transaction' do
      expect {
        command_bus.call(Transactions::Commands::RejectTransaction.new(@reject_params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).creditor_informed }.from(false).to(true)
        .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).status }.from('pending').to('rejected')

      close_params = {
        transaction_uid: @transaction_uid,
        reason_for_closing: 'hwdp #2'
      }

      expect { 
        command_bus.call(Transactions::Commands::CloseTransaction.new(close_params))
      }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid).status }.from('rejected').to('closed')

      expect(event_store).to have_published(
        an_event(Transactions::Events::TransactionIssued),
        an_event(Transactions::Events::TransactionRejected),
        an_event(Transactions::Events::CreditorInformed),
        an_event(Transactions::Events::TransactionClosed).with_data(reason_for_closing: close_params[:reason_for_closing])
      ).in_stream("Transaction$#{@transaction_uid}").strict


    end
  end 
end 
