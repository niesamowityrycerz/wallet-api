require 'rails_helper'


RSpec.describe 'Index endpoint', type: :request do 

  let(:debt_uid)                  { SecureRandom.uuid }
  let(:zloty)                     { create(:currency) }

  let(:creditor)                  { create(:user, :with_repayment_conditions) }
  let(:debtor)                    { create(:user) }

  let(:application)               { create(:application) }
  let(:creditor_access_token)     { create(:access_token, application: application, resource_owner_id: creditor.id) }
  let(:debtor_access_token)       { create(:access_token, application: application, resource_owner_id: debtor.id) }

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
    command_bus.call(Debts::Commands::IssueDebt.send(@issue_tran_params))
  end


  context 'when debtor' do 
    context 'when debt issued' do 
      it 'checks body and links' do 
        get "/api/v1/debt/#{debt_uid}", headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }

        expect(response.status).to eq(200)
        body = response.parsed_body['data']
        expect(body['attributes']).to include('amount', 'status', 'currency', 'debtor', 'creditor', 'issued_at', 'maturity_on', 'description', 
                                              'date_of_transaction', 'expire_in', 'max_date_of_settlement') 
        expect(body['links']).to include('accept', 'reject', 'check_out')
      end 
    end

    context 'when debt accepted' do 

      before(:each) do 
        command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
      end

      it 'checks body and links' do 
        get "/api/v1/debt/#{debt_uid}", headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }
        expect(response.status).to eq(200)

        body = response.parsed_body['data']
        expect(body['attributes']['status']).to eq('accepted')
        expect(body['links']).to include('settle', 'add_anticipated_date_of_return')
      end
    end

    context 'when debt settled' do 

      before(:each) do 
        command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
        command_bus.call(Debts::Commands::SettleDebt.send({debt_uid: debt_uid}))
      end

      it 'checks body and links' do 
        get "/api/v1/debt/#{debt_uid}", headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }
        expect(response.status).to eq(200)
        body = response.parsed_body['data']

        expect(body['attributes']['status']).to eq('closed')
        body = response.parsed_body["data"]
        expect(body['links']).to eq({})
      end
    end
  end
end