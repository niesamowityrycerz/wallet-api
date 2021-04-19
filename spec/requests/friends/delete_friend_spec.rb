require 'rails_helper'

RSpec.describe 'Delete Friend', type: :request do 

  let(:friendship_issuer)     { create(:user) }
  let(:friend)                { create(:user) }
  let(:application)           { create(:application) }
  let(:access_token)          { create(:access_token, application: application, resource_owner_id: friendship_issuer.id) }

  before(:each) do
    @params = { friend_id: friend.id }
  end

  context 'when happy path' do 
    it 'deletes user from friends' do 
      friendship_issuer.friend_request(friend)
      friend.accept_request(friendship_issuer)

      post "/api/v1/friends/delete", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(friendship_issuer.friends).to eq([])
      expect(friend.friends).to eq([])
    end
  end

  context 'when no friendship' do 
    it 'raises error' do
      post "/api/v1/friends/delete", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(response.status).to eq(404)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq('You cannot remove unexisiting friendship')
    end
  end
end