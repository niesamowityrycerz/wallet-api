require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'User leaves group', type: :integration do 

  let(:group_uid)              { SecureRandom.uuid }
  let(:leader)                 { create(:user) }
  let(:friends_of_leader)      { create_list(:user, 3) }
  let(:not_member_user)        { create(:user) }

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


  context 'when user is a member' do
    before(:each) do 
      @leaving_user = friends_of_leader.sample
      command_bus.call(Groups::Commands::AcceptInvitation.send({
        group_uid: group_uid,
        member_id: @leaving_user.id
      }))
    end

    it 'leaves group' do
      before = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members
      after = before - [@leaving_user.id]
      data = {
        group_uid: group_uid,
        member_id: @leaving_user.id
      }

      expect {
        command_bus.call(Groups::Commands::LeaveGroup.send(data))
      }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members}.from(before).to(after)
    end
  end

  context 'when user is NOT a member' do 
    it 'raises error' do 
      data = {
        group_uid: group_uid,
        member_id: not_member_user.id
      }

      expect {
        command_bus.call(Groups::Commands::LeaveGroup.send(data))
      }.to raise_error(Groups::GroupAggregate::OperationNotPermitted)
    end
  end
end