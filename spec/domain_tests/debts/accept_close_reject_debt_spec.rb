require 'rails_helper'

RSpec.describe 'Debt actions on happy path', type: :unit do 
  
  let(:debt_uid)                { SecureRandom.uuid }
  let(:creditor)                { create(:creditor, :with_ranking_position) }
  let(:debtor)                  { create(:debtor, :with_ranking_position) }
  let(:zloty)                   { create(:currency) }
  let(:euro)                    { create(:currency, :euro) }
  let(:one_instalment)          { create(:settlement_method) }
  let!(:repayment_condition)    { create(:repayment_condition, :maturity_in_10_days, creditor: creditor, currency: zloty, settlement_method: one_instalment) }
  let!(:debt_projection)        { create(:debt_projection, :pending, debt_uid: debt_uid) }

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
  end

  it 'closes debt' do
    command_bus.call(Debts::Commands::IssueDebt.new(@issue_tran_params))
    params = {
      debt_uid: debt_uid,
      reason_for_closing: 'wrong debtor'
    }

    expect {
      command_bus.call(Debts::Commands::CloseDebt.new(params))
    }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('pending').to('closed') 

    expect(event_store).to have_published(
      an_event(Debts::Events::DebtClosed).with_data(reason_for_closing: params[:reason_for_closing])
    ).in_stream("Debt$#{debt_uid}")
  end

  it 'rejects debt' do
    params = {
      debt_uid: debt_uid,
      reason_for_rejection: 'I do not know u!'
    }

    expect {
      command_bus.call(Debts::Commands::RejectDebt.new(params))
    }.to change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).reason_for_rejection }.from(nil).to(params[:reason_for_rejection])
      .and change { ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid).status }.from('pending').to('rejected')

    expect(event_store).to have_published(
      an_event(Debts::Events::DebtRejected)
    ).in_stream("Debt$#{debt_uid}").strict
  end
end