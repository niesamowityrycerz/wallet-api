require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Accept invitation endpoint', type: :request do 

  let(:group_uid)                 { SecureRandom.uuid }
  let(:leader)                    { create(:user) }
  let(:friends_of_leader)         { create_list(:user, 3) }
  let(:random_user)               { create(:user) }
  let(:euro)                      { create(:currency, :euro) }

  let(:application)               { create(:application) }
  let(:invited_user_access_token) { create(:access_token, application: application, resource_owner_id: friends_of_leader.sample.id) }
  let(:random_user_access_token)  { create(:access_token, application: application, resource_owner_id: random_user.id) }

  before(:each) do 
    create_friendships(leader, friends_of_leader)
    @register_group_params = {
      group_uid: group_uid,
      leader_id: leader.id,
      invited_users: friends_of_leader.map(&:id),
      group_name: Faker::Address.country + "_#{rand(1..100)}",
      from: Date.today,
      to: Date.today + rand(5..15)
    }
    command_bus.call(Groups::Commands::RegisterGroup.send(@register_group_params))
  end

  context 'when group exists' do 
    context 'when invited user' do 
      it 'accepts invitation' do 
        patch "/api/v1/group/#{group_uid}/accept", headers: { 'Authorization': 'Bearer ' + invited_user_access_token.token }
        expect(response.status).to eq(201)
      end 
    end

    context 'when random user' do 
      it 'raises error' do 
        patch "/api/v1/group/#{group_uid}/accept", headers: { 'Authorization': 'Bearer ' + random_user_access_token.token }

        expect(response.status).to eq(403)
        expect(response.parsed_body['error']).to eq('You cannot do that!')
      end 
    end
  end 
end 