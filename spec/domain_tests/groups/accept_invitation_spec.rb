require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe "Accept invitation flow", type: :integration do 

  let(:group_uid)                { SecureRandom.uuid }
  let(:leader)                   { create(:user) }
  let(:friends_of_leader)        { create_list(:user, 3) }
  let(:random_user)              { create(:user) }


  before(:each) do 
    create_friendships(leader, friends_of_leader)
    @register_group_params = {
      group_uid: group_uid,
      leader_id: leader.id,
      invited_users: friends_of_leader.collect {|member| member.id },
      group_name: Faker::Address.country + "_#{rand(1..100)}",
      from: Date.today,
      to: Date.today + rand(5..15)
    }
    command_bus.call(Groups::Commands::RegisterGroup.send(@register_group_params))
  end

  context 'when invited user' do 
    it 'accepts invitation to group' do
      sampled_user_id = friends_of_leader.sample.id
      data = { 
        group_uid: group_uid,
        member_id: sampled_user_id
      }

      expect {
        command_bus.call(Groups::Commands::AcceptInvitation.send(data))
      }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members }.from(Array.new([leader.id])).to(Array.new([leader.id, sampled_user_id]))
        .and change { WriteModels::GroupMember.find_by(group_uid: group_uid, member_id: sampled_user_id).invitation_status }.from("waiting").to("accepted")

      expect(event_store).to have_published(
        an_event(Groups::Events::InvitationAccepted).with_data({
          member_id: sampled_user_id
        })
      ).in_stream("Group$#{group_uid}")
    end
  end 

  context 'when user was not invited' do 
    it 'raises error on accepting invitation' do
      data = { 
        group_uid: group_uid,
        member_id: random_user.id
      }

      expect {
        command_bus.call(Groups::Commands::AcceptInvitation.send(data))
      }.to raise_error(Groups::GroupAggregate::OperationNotPermitted)

      expect(event_store).not_to have_published(
        an_event(Groups::Events::InvitationAccepted)
      ).in_stream("Group$#{group_uid}")
    end
  end 
end 