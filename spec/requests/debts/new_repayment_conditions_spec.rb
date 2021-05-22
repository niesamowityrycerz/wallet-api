require 'rails_helper'

RSpec.describe 'New repayment conditions endpoint', type: :request do 

  let(:debt_uid)                  { SecureRandom.uuid }
  let(:invalid_debt_uid)          { SecureRandom.uuid }
  let(:creditor)                  { create(:user, :with_repayment_conditions) }
  let(:debtor)                    { create(:debtor) }
  let(:zloty)                     { create(:currency) }
  let(:euro)                      { create(:currency, :euro) }

  let(:application)               { create(:application) }
  let(:creditor_access_token)     { create(:access_token, application: application, resource_owner_id: creditor.id) }
  let(:debtor_access_token)       { create(:access_token, application: application, resource_owner_id: debtor.id) }

  before(:each) do 
    @issue_debt_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
    command_bus.call(Debts::Commands::IssueDebt.send(@issue_debt_params))

    @params = {
      currency_id: euro.id,
      maturity_in_days: 10
    }
  end

  context 'when debt status == :pending' do 
    context 'when creditor' do 
      it 'overwrites basic repayment conditions' do 
        put "/api/v1/debt/#{debt_uid}/new_repayment_conditions", params: @params, headers: { 'Authorization': 'Bearer ' + creditor_access_token.token }

        expect(response.status).to eq(201)
        expect(event_store).to have_published(
          an_event(Debts::Events::RepaymentConditionsOverwrote)
        ).in_stream("Debt$#{debt_uid}")
      end
    end 

    context 'when debtor' do 
      it 'raises error on attempt to overwrite conditions' do 
        put "/api/v1/debt/#{debt_uid}/new_repayment_conditions", params: @params, headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }

        expect(response.status).to eq(403)
        expect(response.parsed_body['error']).to eq('You cannot do that!')
      end
    end 
  end 

  context 'when debts status != :pending' do 

    before(:each) do 
      command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
    end

    it 'raises error on attempt to overwrite conditions' do 
      put "/api/v1/debt/#{debt_uid}/new_repayment_conditions", params: @params, headers: { 'Authorization': 'Bearer ' + creditor_access_token.token }

      expect(response.status).to eq(403)
      expect(response.parsed_body['error']).to eq('It is too late to do that!')
    end
  end

  context 'when debt does not exist' do 
    it 'raises error on attempt to overwrite conditions' do 
      put "/api/v1/debt/#{invalid_debt_uid}/new_repayment_conditions", params: @params, headers: { 'Authorization': 'Bearer ' + creditor_access_token.token }

      expect(response.status).to eq(404)
      expect(response.parsed_body['error']).to eq('We could not find the requested resource!')
    end
  end
end