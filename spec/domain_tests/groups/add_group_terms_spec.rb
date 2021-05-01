require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Group functionality', type: :unit do 


  let(:group_uid)                { SecureRandom.uuid }
  let(:leader)                   { create(:user) }
  let(:friends_of_leader)        { create_list(:user, 3) }
  let(:zloty)                    { create(:currency, code: "PLN") }
  

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

    @group_settlement_param = {
      currency_id: zloty.id,
      debt_repayment_valid_till: Date.today + 30
    }
  end


  context 'when group exists' do 
    it 'adds settlement terms' do 
      @group_settlement_param[:group_uid] = group_uid
      expect {
        command_bus.call(Groups::Commands::AddGroupSettlementTerms.send(@group_settlement_param))
      }.to change { ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).currency }.from(nil).to(zloty.code)
       .and change  {ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).debt_repayment_valid_till }.from(nil).to(@group_settlement_param[:debt_repayment_valid_till])
    end
  end

  context 'when group does not exist' do 
    it 'raises error on adding settlement terms' do
      @group_settlement_param[:group_uid] = SecureRandom.uuid
      expect {
        command_bus.call(Groups::Commands::AddGroupSettlementTerms.send(@group_settlement_param))
      }.to raise_error(Groups::GroupAggregate::GroupDoesNotExist)
    end
  end

  context 'when transaction_expire_on in contradiction with group lasting period' do 
    it 'raises error on adding settlement terms' do
      @group_settlement_param[:group_uid] = group_uid
      @group_settlement_param[:debt_repayment_valid_till] = @register_group_params[:from]
      expect {
        command_bus.call(Groups::Commands::AddGroupSettlementTerms.send(@group_settlement_param))
      }.to raise_error(Groups::GroupAggregate::UnpermittedTransactionExpirationDate)
    end
  end
end