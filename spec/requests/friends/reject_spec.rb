require 'rails_helper'

RSpec.describe 'Reject endpoint', type: :request do 

  let(:friendship_issuer)     { create(:user) }
  let(:friend)                { create(:user) }
  let(:application)           { create(:application) }
  let(:access_token)          { create(:access_token, application: application, resource_owner_id: friend.id) }

  context 'when friend request exist' do 
    it 'rejects friend request' do 
      friendship_issuer.friend_request(friend)
      put "/api/v1/friend/#{friendship_issuer.id}/reject", headers: { 'Authorization': 'Bearer ' + access_token.token }
 
      expect(friendship_issuer.pending_friends).to eq([])
      expect(friend.requested_friends).to eq([])
      expect(response.status).to eq(200)
    end
  end

  context 'when no friend request' do 
    it 'raises error' do
      put "/api/v1/friend/#{friendship_issuer.id}/reject", headers: { 'Authorization': 'Bearer ' + access_token.token }

      expect(response.status).to eq(404)
      expect(response.parsed_body["error"]).to eq('Unable to proceed')
    end
  end
end