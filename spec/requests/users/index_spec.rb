require 'rails_helper'

RSpec.describe 'Index endpoint', type: :request do 

  let(:zloty)           { create(:currency) }
  let(:user)            { create(:user, :with_repayment_conditions) }
  let(:logged_user)     { create(:user, :with_repayment_conditions) }
  let(:application)     { create(:application) }
  let(:access_token)    { create(:access_token, application: application, resource_owner_id: logged_user.id) }

  before(:each) do 
    debts_commands = []
    available_users = [user, logged_user]
    10.times do |i|
      sampled_creditor = available_users.sample
      sampled_debtor = available_users.select { |user| user.id != sampled_creditor.id}
      debts_commands << {
        debt_uid: SecureRandom.uuid,
        creditor_id: sampled_creditor.id,
        debtor_id: sampled_debtor[0].id,
        amount:      rand(1.0..100.0).round(2),
        description: 'test',
        currency_id: zloty.id,
        date_of_transaction: Date.today 
      }
    end

    debts_commands.each do |debt_command|
      command_bus.call(Debts::Commands::IssueDebt.send(debt_command))
    end 

    sampled_debts_uids = (debts_commands.collect {|debt| debt[:debt_uid]}).sample(8)
    sampled_debts_uids.each do |debt_uid|
      command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
    end
  end

  context 'when unlogged visitor' do 
    it 'shows user public profile' do 
      get "/api/v1/user/#{user.id}"
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["data"]["attributes"]).to eq({
        "username" => user.username,
        "email" => user.email
      })
    end
  end

  context 'when logged in visitor' do 
    it 'shows user public profile' do
      get "/api/v1/user/#{user.id}", headers: { "Authorization": "Bearer " + access_token.token }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      visitor_debts = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND creditor_id = ?", logged_user.id, user.id)
      visited_user_debts = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND creditor_id = ?", user.id, logged_user.id)

      expect(parsed_body["data"]["meta"]).to eq({
        "visitor_sum_of_accepted_debts" => visitor_debts.accepted.sum("amount").round(2),
        "visitor_sum_of_acceted_credits"=> visited_user_debts.accepted.sum("amount").round(2),
        "debts_quantity" => visitor_debts.count, 
        "credits_quantity"=> visited_user_debts.count
      })
    end
  end

  context 'when api/:version/user/:user_id user_id == logged.id' do 
    subject { get "/api/v1/user/#{logged_user.id}", headers: { "Authorization": "Bearer " + access_token.token } }
    it 'gets redirect to /me' do 
      expect(subject).to redirect_to("/api/v1/me")
    end
  end

  
end