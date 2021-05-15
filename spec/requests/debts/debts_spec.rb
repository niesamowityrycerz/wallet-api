require 'rails_helper'


RSpec.describe 'Debts', type: :request do 

  # users have to have set repayment conditions 
  let(:euro)                      { create(:currency, :euro) }
  let(:zloty)                     { create(:currency) }
  let(:creditor)                  { create(:user) }
  let(:debtor)                    { create(:user) }
  let(:vanila_user)               { create(:user) }
  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: debtor.id) }
  let(:access_token_vanila_user)  { create(:access_token, application: application, resource_owner_id: vanila_user.id) }

  before(:each) do
    users = [debtor, creditor]
    2.times do |i|
      @debt_data = { 
        debt_uid: SecureRandom.uuid,
        creditor_id: users.pop.id,
        debtor_id:   users.last.id,
        amount:      rand(1.0..100.0).round(2),
        description: "test_#{i}",
        currency_id: [euro.id, zloty.id].sample,
        date_of_transaction: Date.today + rand(1..5)
      }
      command_bus.call(Debts::Commands::IssueDebt.send(@debt_data))
    end
  end

  context 'when user has debts/credits' do 
    it 'checks output' do 
      get "/api/v1/debts", headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      binding.pry 
    end 
  end

  context 'when user has no debts/credits' do 
    it 'returns empty' do 
      get "/api/v1/debts", headers: { 'Authorization': 'Bearer ' + access_token_vanila_user.token }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      binding.pry 
      expect(parsed_body).to eq([])
    end
  end





end