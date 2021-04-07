require 'rails_helper'
require 'shared_examples/transactions/filter_on_status_spec'

RSpec.describe 'Filters applied on transactions', type: :request do 


  let(:admin)                     { create(:user, :admin) }
  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: admin.id) }

  before(:all) do 
    per_user_transaction = 5
    users = create_list(:user, 10)

    users.each do |creditor|
      debtor_ids = users.map { |user| user.id } 
      debtor_ids.select! { |id| id != creditor.id }
      create_list(:transaction_projection, 5, creditor_id: creditor.id, debtor_id: debtor_ids.sample, status: %i[pending accepted rejected].sample)
    end
  end

  it_should_behave_like 'on filtering with status', status = :pending
  it_should_behave_like 'on filtering with status', status = :rejected
  it_should_behave_like 'on filtering with status', status =  :accepted

  context 'when admin' do
    it 'filters using amount' do 
      params = {
        transaction_filters: {
          amount: {
            max: 100,
            min: 10
          }
        }
      }
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      amount_range = (params[:transaction_filters][:amount][:min]...params[:transaction_filters][:amount][:max])
      expected = ReadModels::Transactions::TransactionProjection.where(amount: amount_range).to_json
      expect(response.body).to eq(expected)
    end


    it 'filters using date of transaction' do 
      params = {
        transaction_filters: {
          date_of_transaction: {
            from: (Date.today - 2).as_json,
            to: Date.today.as_json 
          }
        }
      }
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      date_range = (params[:transaction_filters][:date_of_transaction][:from]..params[:transaction_filters][:date_of_transaction][:to])
      expected = ReadModels::Transactions::TransactionProjection.where(date_of_transaction: date_range).to_json 
      expect(response.body).to eq(expected)
    end


    it 'filters with status combination' do 
      params = {
        transaction_filters: {
          status: [:accepted, :pending]
        }
      }
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      accepted = ReadModels::Transactions::TransactionProjection.all.accepted 
      pending = ReadModels::Transactions::TransactionProjection.all.pending 
      all = accepted + pending
      expected_ids = all.map { |i| i.id }

      parsed_response = JSON.parse(response.body)
      response_ids = parsed_response.map { |i| i["id"] }

      expect(response_ids).to match_array( expected_ids )
    end

    it 'filters with debtor' do 
      debtor = User.all.sample 
      params = {
        transaction_filters: {
          debtors: [ debtor ]
        }
      }

      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expected = ReadModels::Transactions::TransactionProjection.where(debtor_id: params[:transaction_filters][:debtors].map { |user| user.id } ).to_json 
      expect(response.body).to eq(expected)



    end
  end


end