require 'rails_helper'

RSpec.describe 'Check out endpoint', type: :request do 

  let(:debt_uid)                  { SecureRandom.uuid }
  let(:zloty)                     { create(:currency) }
  let(:debtor)                    { create(:debtor) }

  let(:creditor)                  { create(:user, :with_repayment_conditions) }
  let(:debtor)                    { create(:user) }
  let(:random_user)               { create(:user) }

  let(:application)               { create(:application) }
  let(:random_user_access_token)  { create(:access_token, application: application, resource_owner_id: random_user.id) }
  let(:creditor_access_token)     { create(:access_token, application: application, resource_owner_id: creditor.id) }

  before(:each) do
    @issue_tran_params = {
      debt_uid: debt_uid,
      creditor_id: creditor.id,
      debtor_id:   debtor.id,
      amount:      rand(1.0..100.0).round(2),
      description: 'test',
      currency_id: zloty.id,
      date_of_transaction: Date.today 
    }
    command_bus.call(Debts::Commands::IssueDebt.send(@issue_tran_params))

    # from 4 different debt details, corrects 2
    @params = {
      amount: rand(10.0..1000.0).round(2),
      description: Faker::Movies::HarryPotter.book
    }
  end

  context 'when debt status == :under_scrutiny' do 

    before(:each) do 
      command_bus.call(Debts::Commands::CheckOutDebtDetails.send({
        debt_uid: debt_uid,
        doubts: 'I have doubts'
      }))
    end

    context 'when creditor' do 
      context 'when valid parameters' do 
        it 'corrects debt details' do 
          patch "/api/v1/debt/#{debt_uid}/correct", params: @params, headers: { 'Authorization': 'Bearer ' + creditor_access_token.token }
          expect(response.status).to eq(200)
        end 
      end 
    end

    context 'when current user is not debtor' do 
      it 'raises error' do 
        patch "/api/v1/debt/#{debt_uid}/correct", params: @params, headers: { 'Authorization': 'Bearer ' + random_user_access_token.token }
  
        expect(response.status).to eq(403)
        expect(response.parsed_body['error']).to eq('You are not entitled to do this!')
      end
    end
  end

  context 'when debt status != :under_scrutiny' do 

    before(:each) do 
      command_bus.call(Debts::Commands::AcceptDebt.send({debt_uid: debt_uid}))
    end

    it 'raises error' do 
      patch "/api/v1/debt/#{debt_uid}/correct", params: @params, headers: { 'Authorization': 'Bearer ' + creditor_access_token.token }

      expect(response.status).to eq(403)
      expect(response.parsed_body['error']).to eq('This option is unavailable.')
    end
  end
end 
