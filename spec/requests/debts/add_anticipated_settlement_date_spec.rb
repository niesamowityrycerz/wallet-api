require 'rails_helper'


RSpec.describe 'Add anticipated settlememnt date endpoint', type: :request do 

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

    @params = {
      anticipated_date_of_settlement: Date.today + rand(1..5)
    }
  end

  context 'when debt accepted' do 

    before(:each) do 
      command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
    end

    it 'adds anticipated date of return' do 
      patch "/api/v1/debt/#{debt_uid}/add_anticipated_settlement_date", params: @params, headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }
      expect(response.status).to eq(200)
    end
  end

  context 'when debt not accepted' do 
    it 'raises error' do 
      patch "/api/v1/debt/#{debt_uid}/add_anticipated_settlement_date", params: @params, headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }
      expect(response.status).to eq(403)
      expect(response.parsed_body['error']).to eq('Accept debt first!')
    end
  end
end 



