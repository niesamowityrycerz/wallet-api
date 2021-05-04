require 'rails_helper'
require 'helpers/friendships'

include Friendship


RSpec.describe 'Multiple debts at once actions', type: :unit do 

  let(:group_uid)             { SecureRandom.uuid }
  let(:leader)                { create(:user) }
  let(:friends_of_leader)     { create_list(:user, 3) }
  let(:zloty)                 { create(:currency) }

  before(:each) do
    create_friendships(leader, friends_of_leader)

    command_bus.call(Groups::Commands::RegisterGroup.send({
      group_uid: group_uid,
      leader_id: leader.id,
      group_name: Faker::Address.country + "_#{rand(1..100)}",
      from: Date.today,
      to: Date.today + rand(5..15),
      invited_users: leader_friends.collect {|user| user.id }
    }))

    command_bus.call(Groups::Commands::AddGroupSettlementTerms.send({
      group_uid: group_uid,
      currency_id: zloty.id,
      debt_repayment_valid_till: Date.today + 30
    }))


    @issue_debt_params = {
      creditor_id: leader.id,
      debtor_id: friends_of_leader.sample.id,
      amount: 100.0,
      description: 'test',
      currency_id: zloty.id,
      group_uid: group_uid,
      debt_uid: SecureRandom.uuid
    }
  end

  context 'when within group' do
    it 'issues debt to one member' do
      command_bus.call(
        Debts::Commands::IssueDebt.send(@issue_debt_params)
      )

      expect(event_store).to have_published(
        an_event(Debts::Events::DebtIssued)
      ).in_stream("Group$#{group_uid}")

    end
  end

  



  

  
end