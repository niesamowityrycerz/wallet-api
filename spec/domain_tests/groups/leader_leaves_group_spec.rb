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


  context 'when leader' do 
    context 'when other members exist'
      before(:each) do 
        @other_member = friends_of_leader.sample
        command_bus.call(Groups::Commands::AcceptInvitation.send({
          group_uid: group_uid,
          member_id: @other_member.id
        }))
      end

      it 'leaves group and assigns new leader' do 
        before = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members
        after = before - [leader.id]
        data = {
          group_uid: group_uid,
          member_id: leader.id
        }

        expect {
          command_bus.call(Groups::Commands::LeaveGroup.send(data))
        }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members}.from(before).to(after)
      
        expect(ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).leader_id).not_to eq(leader.id)
        expect(event_store).to have_published(
          an_event(Groups::Events::GroupLeft).with_data(user_id: leader.id),
          an_event(Groups::Events::GroupLeaderChanged)
        ).in_stream("Group$#{group_uid}")
      end
    end 

    context 'when othert members do NOT exist' do 
      it 'leaves group and assigns new leader' do 
        before = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members
        after = before - [leader.id]
        data = {
          group_uid: group_uid,
          member_id: leader.id
        }

        expect {
          command_bus.call(Groups::Commands::LeaveGroup.send(data))
        }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members}.from(before).to(after)

        expect(event_store).not_to have_published(
          an_event(Groups::Events::GroupLeaderChanged)
        ).in_stream("Group$#{group_uid}")
        
        # expect closing group state 
      end
    end
  end