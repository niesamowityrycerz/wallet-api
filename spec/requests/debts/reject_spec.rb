require 'rails_helper'


RSpec.describe 'Reject endpoint', type: :request do 

  let(:debt_uid)                  { SecureRandom.uuid }
  let(:zloty)                     { create(:currency) }
  let(:debtor)                    { create(:debtor) }

  let(:creditor)                  { create(:user, :with_repayment_conditions) }
  let(:debtor)                    { create(:user) }
  let(:random_user)               { create(:user) }

  let(:application)               { create(:application) }
  let(:random_user_access_token)  { create(:access_token, application: application, resource_owner_id: random_user.id) }
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
      debt_uid: debt_uid, 
      reason_for_rejection: 'test'
    }
  end

  context 'when debt issud' do 
    context 'when debtor' do 
      it 'rejects debt' do 
        patch "/api/v1/debt/#{debt_uid}/reject", params: @params, headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }

        expect(response.status).to eq(200)
      end 
    end
  end

  context 'when current user is not debtor' do 
    it 'raise error' do 
      patch "/api/v1/debt/#{debt_uid}/reject", params: @params, headers: { 'Authorization': 'Bearer ' + random_user_access_token.token }

      expect(response.status).to eq(403)
      expect(response.parsed_body["error"]).to eq('You are not entitled to do this!')
    end
  end

  context 'when absence of parameter' do 
    it 'raises error' do 
      @params.delete(:reason_for_rejection)
      patch "/api/v1/debt/#{debt_uid}/reject", params: @params, headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }

      expect(response.status).to eq(400)
      expect(response.parsed_body[0]).to eq({"params" => ["reason_for_rejection"], "messages" => ["is missing"]})
    end
  end
end