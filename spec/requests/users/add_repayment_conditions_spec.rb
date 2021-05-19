require 'rails_helper'

RSpec.describe 'Add repayment conditions endpoint', type: :request do 

  let(:user)            { create(:user) }
  let(:zloty)           { create(:currency) }
  
  let(:application)     { create(:application) }
  let(:access_token)    { create(:access_token, application: application, resource_owner_id: user.id) }

  before(:each) do 
    @params = {
      currency_id: zloty.id,
      maturity_in_days: rand(1..365)
    }
  end

  it 'adds repayment conditions' do 
    post "/api/v1/user/#{user.id}/add_repayment_conditions", params: @params, headers: { "Authorization": "Bearer " + access_token.token }
  end
end