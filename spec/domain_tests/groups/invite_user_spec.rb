require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Invite user to group', type: :integration do 

  let(:group_uid)              { SecureRandom.uuid }
  let(:leader)                 { create(:user) }
  let(:friends_of_leader)      { create_list(:user, 4) }
  let(:unknown_to_leader)       { create(:user) }


  before(:each) do 
    create_friendships(leader, friends_of_leader)
    @register_group_params = {
      group_uid: group_uid,
      leader_id: leader.id,
      invited_users: friends_of_leader.pop(rand(1..3)).map(&:id),
      group_name: Faker::Address.country + "_#{rand(1..100)}",
      from: Date.today,
      to: Date.today + rand(5..15)
    }
    command_bus.call(Groups::Commands::RegisterGroup.send(@register_group_params))
  end

  context 'when invited user and leader are friends' do 
    it 'invites to group' do 
      params = {
        group_uid: group_uid,
        user_id: friends_of_leader.last.id
      }

      expect {
        command_bus.call(Groups::Commands::InviteUser.send(params))
      }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).invited_users.count }.by(1)

      expect(event_store).to have_published(
        an_event(Groups::Events::UserInvited)
      ).in_stream("Group$#{group_uid}")
    end
  end

  context 'when invited user and leader are NOT friends' do 
    it 'raises error' do 
      params = {
        group_uid: group_uid,
        user_id: unknown_to_leader.id
      }

      expect {
        command_bus.call(Groups::Commands::InviteUser.send(params))
      }.to raise_error(Groups::GroupAggregate::MemberNotAllowed)
    end
  end
end