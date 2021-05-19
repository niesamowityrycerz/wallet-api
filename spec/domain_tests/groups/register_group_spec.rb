require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Group functionality', type: :unit do 

  let(:group_uid)                { SecureRandom.uuid }
  let(:leader)                   { create(:user) }
  let(:friends_of_leader)        { create_list(:user, 3) }
  let(:not_friends_with_leader)  { create_list(:user, 3) }


  before(:each) do 
    @register_group_params = {
      group_uid: group_uid,
      leader_id: leader.id,
      group_name: Faker::Address.country + "_#{rand(1..100)}",
      from: Date.today,
      to: Date.today + rand(5..15)
    }
  end

  context 'when invited users are friends with leader' do
    it 'regiters group' do
      create_friendships(leader, friends_of_leader)
      @register_group_params[:invited_users] = friends_of_leader.map(&:id)

      expect {
        command_bus.call(Groups::Commands::RegisterGroup.send(@register_group_params))
      }.to change { ReadModels::Groups::GroupProjection.count }.by(1)
      .and change { WriteModels::Group.count }.by(1)

      expect(event_store).to have_published(
        an_event(Groups::Events::GroupRegistered)
      ).in_stream("Group$#{group_uid}")
    end
  end

  context 'when invited users are not friends with leader' do 
    it 'raises error on registering group' do 
      @register_group_params[:invited_users] = not_friends_with_leader.map(&:id)

      expect {
        command_bus.call(Groups::Commands::RegisterGroup.send(@register_group_params))
      }.to raise_error(Groups::GroupAggregate::MemberNotAllowed)

      expect(event_store).not_to have_published(
        an_event(Groups::Events::GroupRegistered)
      ).in_stream("Group$#{group_uid}")
    end
  end 
end