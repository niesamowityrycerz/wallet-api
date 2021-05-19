require 'rails_helper'


RSpec.describe 'Issue debt endpoint', type: :request do 

  let(:zloty)                     { create(:currency) }
  let(:debtor)                    { create(:debtor) }

  let(:user)                      { create(:user, :with_repayment_conditions) }
  let(:plain_user)                { create(:user) }

  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: user.id) }
  let(:plain_user_access_token)   { create(:access_token, application: application, resource_owner_id: plain_user.id) }

  before(:each) do
    @params = { 
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
  end

  context 'when happy path' do 
    context 'when user issues debt' do 
      it 'checks response' do 
        post "/api/v1/debt/new", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
        debt_uid = ReadModels::Debts::DebtProjection.last.debt_uid

        expect(response).to redirect_to("/api/v1/debt/#{debt_uid}")
        expect(response.status).to eq(301)
      end 
    end
  end

  context 'when issuer does not have repayment conditions' do 
    it 'raise error' do 
      post "/api/v1/debt/new", params: @params, headers: { 'Authorization': 'Bearer ' + plain_user_access_token.token }

      expect(response.parsed_body["error"]).to eq("You have to set repayment conditions first!")
    end
  end
end