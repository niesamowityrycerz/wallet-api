require 'rails_helper'

RSpec.describe 'Accept endpoint', type: :request do 

  let(:friendship_issuer)     { create(:user) }
  let(:to_be_friend)          { create(:user) }
  let(:application)           { create(:application) }
  let(:access_token)          { create(:access_token, application: application, resource_owner_id: to_be_friend.id) }

  before(:each) do 
    @params = {
      user_id: friendship_issuer.id
    }
  end

  context 'when happy path' do 
    it 'accepts request' do
      friendship_issuer.friend_request(to_be_friend)
      put "/api/v1/friend/accept", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      expect(friendship_issuer.friends).to include(to_be_friend)
      expect(to_be_friend.friends).to include(friendship_issuer)
    end
  end

  context 'when request has not been sent' do 
    it 'raises error' do
      put "/api/v1/friend/accept", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      expect(response.status).to eq(404)
      expect(response.parsed_body["error"]).to eq('Unable to proceed')
    end
  end

end