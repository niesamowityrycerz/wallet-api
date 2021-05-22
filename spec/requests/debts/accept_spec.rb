require 'rails_helper'


RSpec.describe 'Accept endpoint', type: :request do 

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

    @accept_params = {
      debt_uid: debt_uid,
      debtor_id: debtor.id
    }
  end

  context 'when debt issud' do 
    context 'when debtor' do 
      it 'accepts debt' do 
        patch "/api/v1/debt/#{debt_uid}/accept", params: @accept_params, headers: { 'Authorization': 'Bearer ' + debtor_access_token.token }

        expect(response.status).to eq(200)
      end 
    end
  end

  context 'when current user is not debtor' do 
    it 'raise error' do 
      @accept_params[:debtor_id] = random_user.id
      patch "/api/v1/debt/#{debt_uid}/accept", params: @accept_params, headers: { 'Authorization': 'Bearer ' + random_user_access_token.token }

      expect(response.status).to eq(403)
      expect(response.parsed_body["error"]).to eq('You are not entitled to do this!')
    end
  end

  context 'when debt uid does not exist' do 
    it 'raises error' do 
      unexisiting_debt_uid = SecureRandom.uuid 
      patch "/api/v1/debt/#{unexisiting_debt_uid}/accept", params: @accept_params, headers: { 'Authorization': 'Bearer ' + random_user_access_token.token }

      expect(response.status).to eq(404)
      expect(response.parsed_body["error"]).to eq("We could not find the requested resource!")
    end
  end
end