require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Close group', type: :integration do 

  let(:group_uid)              { SecureRandom.uuid }
  let(:leader)                 { create(:user) }
  let(:friends_of_leader)      { create_list(:user, 3) }


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

    @close_group_params = {
      group_uid: group_uid
    }
  end

  context 'when leader' do 
    it 'closes group' do
      @close_group_params[:user_id] = leader.id     
      expect {
        command_bus.call(Groups::Commands::CloseGroup.send(@close_group_params))
      }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).state }.from("init").to("closed")
    end
  end

  context 'when non-leader' do 
    it 'raises error' do 
      @close_group_params[:user_id] = friends_of_leader.sample.id   
      expect {
        command_bus.call(Groups::Commands::CloseGroup.send(@close_group_params))
      }.to raise_error(Groups::GroupAggregate::NotEntitledToCloseGroup)
    end
  end
end