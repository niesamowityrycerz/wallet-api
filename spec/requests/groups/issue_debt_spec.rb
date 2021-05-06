require 'rails_helper'
require 'helpers/friendships'

include Friendship

RSpec.describe 'Issue splitted debt', type: :request do 

  let(:group_uid)                 { SecureRandom.uuid }
  let(:leader)                    { create(:user) }
  let(:leader_friends)            { create_list(:user, 3) }
  let(:zloty)                     { create(:currency) }

  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: leader.id) }

  before(:each) do 
    create_friendships(leader, leader_friends)

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
  end
  
  context 'when access permitted' do 
    context 'when split debt among picked group members' do
      it 'issues debts' do
        params = {
          description: 'test',
          currency_id: zloty.id,
          credit_equally: true,
          debtors_ids: leader_friends.collect{ |user| user.id },
          amount: 100.0,
        }
        post "/api/v1/groups/#{group_uid}/issue_debt", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }

        expect(response.status).to eq(201)
        to_repay_per_debtor = (params[:amount] / params[:debtors_ids].count).round(2)
    
        expect(event_store).to have_published(
          an_event(Debts::Events::DebtIssued).with_data(
            amount: to_repay_per_debtor, debtor_id: leader_friends[0].id, creditor_id: leader.id
          ),
          an_event(Debts::Events::DebtIssued).with_data(
            amount: to_repay_per_debtor, debtor_id: leader_friends[1].id, creditor_id: leader.id
          ),
          an_event(Debts::Events::DebtIssued).with_data(
            amount: to_repay_per_debtor, debtor_id: leader_friends[2].id, creditor_id: leader.id
          )
        ).in_stream("Group$#{group_uid}")
      end
    end

    context 'when no split' do 
      it 'issues debts' do 
        params = {
          description: 'test',
          currency_id: zloty.id,
          credit_equally: false,
          debts_info: [
            {
              debtor_id: leader_friends[0].id,
              amount: rand(1..100)
            },
            {
              debtor_id: leader_friends[1].id,
              amount: rand(1..100)
            },
            {
              debtor_id: leader_friends[2].id,
              amount: rand(1..100)
            }
          ]
        }
        post "/api/v1/groups/#{group_uid}/issue_debt", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
        expect(response.status).to eq(201)
        expect(event_store).to have_published(
          an_event(Debts::Events::DebtIssued).with_data(
            creditor_id: leader.id, amount: params[:debts_info][0][:amount], debtor_id: leader_friends[0].id
          ),
          an_event(Debts::Events::DebtIssued).with_data(
            creditor_id: leader.id, amount: params[:debts_info][1][:amount], debtor_id: leader_friends[1].id
          ),
          an_event(Debts::Events::DebtIssued).with_data(
            creditor_id: leader.id, amount: params[:debts_info][2][:amount], debtor_id: leader_friends[2].id),
        ).in_stream("Group$#{group_uid}")
      end
    end
  end
end
