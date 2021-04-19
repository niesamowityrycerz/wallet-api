require 'rails_helper'

RSpec.describe 'Accept Friend', type: :request do 

  let(:friendship_issuer)     { create(:user) }
  let(:to_be_friend)          { create(:user) }
  let(:application)           { create(:application) }
  let(:access_token)          { create(:access_token, application: application, resource_owner_id: to_be_friend.id) }

  before(:each) do
    @params = { issuer_id: friendship_issuer.id }
  end

  context 'when happy path' do 
    it 'accepts request' do
      friendship_issuer.friend_request(to_be_friend)
      post "/api/v1/friends/accept", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(friendship_issuer.friends).to include(to_be_friend)
      expect(to_be_friend.friends).to include(friendship_issuer)
    end
  end

  context 'when request has not been sent' do 
    it 'raises error' do
      post "/api/v1/friends/accept", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(response.status).to eq(404)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq('You do not have request from this user!')
    end
  end
end