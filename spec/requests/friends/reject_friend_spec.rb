require 'rails_helper'

RSpec.describe 'Reject Friend', type: :request do 

  let(:friendship_issuer)     { create(:user) }
  let(:friend)                { create(:user) }
  let(:application)           { create(:application) }
  let(:access_token)          { create(:access_token, application: application, resource_owner_id: friend.id) }

  before(:each) do
    friendship_issuer.friend_request(friend)
    @params = { wanabe_friend_id: friendship_issuer.id }
  end

  context 'when happy path' do 
    it 'rejects friend request' do 
      post "/api/v1/friends/reject", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(friendship_issuer.pending_friends).to eq([])
      expect(friend.requested_friends).to eq([])
      expect(response.status).to eq(200)
    end
  end

  #context 'when no friendship' do 
  #  it 'raises error' do
  #    post "/api/v1/friends/delete", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
  #    expect(response.status).to eq(404)
  #    parsed_response = JSON.parse(response.body)
  #    expect(parsed_response["error"]).to eq('You cannot remove unexisiting friendship')
  #  end
  #end
end