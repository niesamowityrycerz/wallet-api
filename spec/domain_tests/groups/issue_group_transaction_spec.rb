require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Group functionality', type: :integration do 

  let(:group_uid)               { SecureRandom.uuid }
  let(:group_transaction_uid)   { SecureRandom.uuid }
  let(:leader)                  { create(:user) }
  let(:friends_of_leader)       { create_list(:user, 3) }
  let(:zloty)                   { create(:currency, code: "PLN") }

  before(:each) do
    create_friendships(leader, friends_of_leader)
    
    command_bus.call(Groups::Commands::RegisterGroup.send({
      group_uid: group_uid,
      leader_id: leader.id,
      invited_users: friends_of_leader.collect {|member| member.id },
      group_name: Faker::Address.country + "_#{rand(1..100)}",
      from: Date.today,
      to: Date.today + rand(5..15)
    }))

    command_bus.call(Groups::Commands::AddGroupSettlementTerms.send({
      group_uid: group_uid,
      currency_id: zloty.id,
      transaction_expired_on: Date.today + 30
    }))

    @params = {
      group_transaction_uid: group_transaction_uid,
      issuer_id: friends_of_leader.first.id,
      total_amount: rand(10.0..100.0).round(2),
      description: "test",
      date_of_transaction: Date.today,
      group_uid: group_uid
    }
  end

  context 'when issuer is also reciever' do 
    it 'issues group transaction' do
      @params[:recievers_ids] = friends_of_leader.push(leader).collect { |user| user.id }
      expect {
        command_bus.call(Groups::Commands::IssueGroupTransaction.send(@params))
      }.to change { ReadModels::Groups::GroupTransactionProjection.count }.by(1)

      expect(event_store).to have_published(
        an_event(Groups::Events::GroupTransactionIssued).with_data(
          group_transaction_uid: group_transaction_uid
        )
      ).in_stream("Group$#{group_uid}")

      expect(ReadModels::Transactions::TransactionProjection.where(group_uid: group_uid).count).to eq(ReadModels::Groups::GroupTransactionProjection.last.recievers_ids.count - 1)
    end
  end 

  context 'when issuer is not reciever' do 
    it 'issues group transaction' do 
      members = friends_of_leader.select {|user| user.id != friends_of_leader.first.id }
      @params[:recievers_ids] = members.push(leader).collect { |user| user.id }

      expect {
        command_bus.call(Groups::Commands::IssueGroupTransaction.send(@params))
      }.to change { ReadModels::Groups::GroupTransactionProjection.count }.by(1)

      expect(event_store).to have_published(
        an_event(Groups::Events::GroupTransactionIssued).with_data(
          group_transaction_uid: group_transaction_uid
        )
      ).in_stream("Group$#{group_uid}")

      expect(ReadModels::Transactions::TransactionProjection.where(group_uid: group_uid).count).to eq(ReadModels::Groups::GroupTransactionProjection.last.recievers_ids.count)
    end
  end


end