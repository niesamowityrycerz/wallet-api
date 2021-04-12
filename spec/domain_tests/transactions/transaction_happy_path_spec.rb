require 'rails_helper'

RSpec.describe 'Transaction actions on happy path', type: :unit do 
  
  let(:transaction_uid)         { SecureRandom.uuid }
  let(:creditor)                { create(:user) }
  let(:debtor)                  { create(:user) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
  let(:one_instalment)          { create(:settlement_method) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }
  let!(:transaction_projection) { create(:transaction_projection, :pending, transaction_uid: transaction_uid) }

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

    @settlement_terms_params = {  
      transaction_uid: transaction_uid,
      debtor_id: debtor.id,
      anticipated_date_of_settlement: Date.today + rand(1..9).day,
      debtor_settlement_method_id: one_instalment.id,
      currency_id: zloty.id 
    }
  end

  it 'issues transaction' do 
    expect {
      command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
    }.to change { ReadModels::Transactions::TransactionProjection.count }.by(1)
      .and change { WriteModels::FinancialTransaction.count }.from(0).to(1)

    expect(event_store).to have_published(
      an_event(Transactions::Events::TransactionIssued)
    ).in_stream("Transaction$#{transaction_uid}").strict 
  end

  it 'accepts transaction' do
    command_bus.call(Transactions::Commands::IssueTransaction.new(@issue_tran_params))
    command_bus.call(Transactions::Commands::AcceptTransaction.new({transaction_uid: transaction_uid}))

    expect(event_store).to have_published(
      an_event(Transactions::Events::TransactionAccepted)
    ).in_stream("Transaction$#{transaction_uid}")
  end

  it 'closes transaction' do
    params = {
      transaction_uid: transaction_uid,
      reason_for_closing: 'Błędna transakcja'
    }

    expect {
      command_bus.call(Transactions::Commands::CloseTransaction.new(params))
    }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).status }.from('pending').to('closed') 

    expect(event_store).to have_published(
      an_event(Transactions::Events::TransactionClosed).with_data(reason_for_closing: params[:reason_for_closing])
    ).in_stream("Transaction$#{transaction_uid}").strict
  end


  it 'rejects transaction' do
    params = {
      transaction_uid: transaction_uid,
      reason_for_rejection: 'hwdp'
    }

    expect {
      command_bus.call(Transactions::Commands::RejectTransaction.new(params))
    }.to change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).reason_for_rejection }.from(nil).to(params[:reason_for_rejection])
      .and change { ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).status }.from('pending').to('rejected')

    expect(event_store).to have_published(
      an_event(Transactions::Events::TransactionRejected)
    ).in_stream("Transaction$#{transaction_uid}").strict
  end
end