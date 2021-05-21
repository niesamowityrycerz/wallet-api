require 'rails_helper'

RSpec.describe 'PUT Balance endpoint', type: :request do 

  let(:user_1)  { create(:user, :with_repayment_conditions) }
  let(:user_2)  { create(:user, :with_repayment_conditions) }
  let(:zloty)   { create(:currency) }

  let(:application)               { create(:application) }
  let(:user_1_access_token)       { create(:access_token, application: application, resource_owner_id: user_1.id) }
  let(:user_2_access_token)       { create(:access_token, application: application, resource_owner_id: user_2.id) }


  before(:each) do 
    3.times do |i|
      @issue_debt_params = {
        debt_uid: SecureRandom.uuid,
        debtor_id:   user_1.id,
        creditor_id: user_2.id,
        amount:      rand(1.0..100.0).round(2),
        description: "test_#{i}",
        currency_id: zloty.id,
        date_of_transaction: Date.today + rand(1..5)
      }
      command_bus.call(
        Debts::Commands::IssueDebt.send(@issue_debt_params)
      )

      @user_1_credits = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND creditor_id = ?", user_2.id, user_1.id).sum('amount')
      @user_2_credits = ReadModels::Debts::DebtProjection.where("debtor_id = ? AND creditor_id = ?", user_1.id, user_2.id).sum('amount')
    end
  end


  context 'when debts have NOT been accepted' do 
    context 'when user entitled' do 
      it 'raises errors' do 
        put "/api/v1/user/#{user_2.id}/balance", headers: { 'Authorization': 'Bearer ' + user_1_access_token.token }

        expect(response.status).to eq(404)
        expect(response.parsed_body["error"]).to eq("Unable to proceed!")
      end
    end
  end 

  context 'when debts have been accepted' do 

    before(:each) do 
      ReadModels::Debts::DebtProjection.pluck(:debt_uid).each do |debt_uid|
        command_bus.call(
          Debts::Commands::AcceptDebt.send({
            debtor_id: user_1.id,
            debt_uid: debt_uid
          })
        )
      end 
    end

    context 'when user entitiled' do 
      it 'balances debts' do
        put "/api/v1/user/#{user_2.id}/balance", headers: { 'Authorization': 'Bearer ' + user_1_access_token.token }

        expect(response.status).to eq(201)
      end
    end

    context 'when user NOT entitled' do 
      it 'raises error' do 
        put "/api/v1/user/#{user_1.id}/balance", headers: { 'Authorization': 'Bearer ' + user_2_access_token.token }

        expect(response.status).to eq(404)
        expect(response.parsed_body["error"]).to eq("Unable to proceed!")
      end
    end
  end
end