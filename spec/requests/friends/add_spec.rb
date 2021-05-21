require 'rails_helper'

RSpec.describe 'Add endpoint', type: :request do 

  let(:friendship_issuer)     { create(:user) }
  let(:to_be_friend)          { create(:user) }

  let(:application)           { create(:application) }
  let(:access_token)          { create(:access_token, application: application, resource_owner_id: friendship_issuer.id) }

  before(:each) do 
    @params = { user_id: to_be_friend.id }
  end

  context 'when happy path' do 
    it 'adds user to friends' do 
      post "/api/v1/friends/add", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      
      expect(friendship_issuer.pending_friends).to include(to_be_friend)
      expect(to_be_friend.requested_friends).to include(friendship_issuer)
    end
  end

  context 'when already friends' do 

    before(:each) do 
      friendship_issuer.friend_request(to_be_friend)
      to_be_friend.accept_request(friendship_issuer)
    end

    it 'raises error' do
      post "/api/v1/friends/add", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      expect(response.status).to eq(404)
      expect(response.parsed_body["error"]).to eq('You are already friends!')
    end
  end

  context 'when sending another friend request' do 
    before(:each) do 
      friendship_issuer.friend_request(to_be_friend)
    end

    it 'raises error' do
      post "/api/v1/friends/add", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      expect(response.status).to eq(404)
      expect(response.parsed_body["error"]).to eq('you have already send a request')
    end
  end
end