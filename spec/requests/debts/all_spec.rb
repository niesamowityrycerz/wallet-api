require 'rails_helper'


RSpec.describe 'All endpoint', type: :request do 

  let(:debt_uid)                  { SecureRandom.uuid }
  let(:euro)                      { create(:currency, :euro) }
  let(:zloty)                     { create(:currency) }
  let(:creditor)                  { create(:user, :with_repayment_conditions ) }
  let(:debtor)                    { create(:user, :with_repayment_conditions) }
  let(:vanila_user)               { create(:user) }

  let(:application)               { create(:application) }

  let(:debtor_access_token)       { create(:access_token, application: application, resource_owner_id: debtor.id) }
  let(:vanila_user_access_token)  { create(:access_token, application: application, resource_owner_id: vanila_user.id) }

  before(:each) do
    @debt_data = { 
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: "test",
      currency_id: [euro.id, zloty.id].sample,
      date_of_transaction: Date.today + rand(1..5)
    }
    command_bus.call(Debts::Commands::IssueDebt.send(@debt_data))
  end

  context 'when user has debts/credits' do 
    it 'checks response body' do 
      get "/api/v1/debts", headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)["data"].first

      expect(parsed_body["links"]["detailed_info"]).to eq("localhost:3000/api/v1/debt/#{debt_uid}")
      expect(parsed_body["attributes"]).to include("amount", "status", "currency", "debtor", "creditor", "maturity_on", "issued_at")
    end 
  end

  context 'when user has no debts or credits' do 
    it 'returns empty Array' do 
      get "/api/v1/debts", headers: { 'Authorization': 'Bearer ' + vanila_user_access_token.token }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['data']).to eq([])
    end
  end
end