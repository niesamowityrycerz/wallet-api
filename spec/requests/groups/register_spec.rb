require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Register endpoint', type: :request do 

  let(:leader)                    { create(:user) }
  let(:friends_of_leader)         { create_list(:user, 3) }
  let(:not_friends_with_leader)   { create_list(:user, 3) }

  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: leader.id) }

  before(:each) do 
    create_friendships(leader, friends_of_leader)
    @params = {
      invited_users: friends_of_leader.map(&:id),
      group_name: Faker::Music::Hiphop.artist,
      from: Date.today,
      to: Date.today + rand(5..30)
    }
  end

  context 'when valid parameters' do 
    it 'registers group' do 
      post "/api/v1/group/register", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      created_group = ReadModels::Groups::GroupProjection.last
      
      expect(response).to redirect_to("/api/v1/group/#{created_group.group_uid}")
    end
  end

  context 'when invited users are not friends of group leader' do 
    it 'raises error' do 
      @params[:invited_users].pop 
      @params[:invited_users] << not_friends_with_leader.first.id 

      post "/api/v1/group/register", params: @params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expect(response.status).to eq(403)
      expect(response.parsed_body["error"]).to eq("#{not_friends_with_leader.first.username} is not your friend!")
    end
  end

end