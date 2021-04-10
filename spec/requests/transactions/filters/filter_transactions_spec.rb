require 'rails_helper'
require 'shared_examples/transactions/filter_on_status_spec'

def params_template(key, value) 
  base = {
            transaction_filters: {}
          }
  base[:transaction_filters][key] = value 
  base 
end


RSpec.describe 'Filters applied on transactions', type: :request do 


  let(:admin)                     { create(:user, :admin) }
  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: admin.id) }
  

  before(:all) do 
    per_user_transaction = 5
    pln = create(:currency, name: "Złoty Polski", code: 'PLN')
    users = create_list(:user, 10)

    @our_user      = User.all.sample
    @application_2  = create(:application) 
    @access_token_2 = create(:access_token, application: @application_2, resource_owner_id: @our_user.id) 
  
    users.each do |creditor|
      debtor_ids = users.map { |user| user.id } 
      debtor_ids.select! { |id| id != creditor.id }
      create_list(:transaction_projection, 5, creditor_id: creditor.id, debtor_id: debtor_ids.sample, status: %i[pending accepted rejected].sample, currency_id: pln.id)
    end
  end

  # RED; INVALID RESPONSE DATA(TO SERIALIZED)
  #it_should_behave_like 'on filtering with status', status = :pending
  #it_should_behave_like 'on filtering with status', status = :rejected
  #it_should_behave_like 'on filtering with status', status =  :accepted

  context 'when admin' do
    it 'filters using amount' do 
      params = params_template(:amount, {max: 100, min: 10})
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      amount_range = (params[:transaction_filters][:amount][:min]...params[:transaction_filters][:amount][:max])
      raw_data = ReadModels::Transactions::TransactionProjection.where(amount: amount_range)
      expected = ::AllTransactionsSerializer.new(raw_data).serializable_hash.to_json

      expect(response.body).to eq(expected)
    end


    it 'filters using date of transaction' do 
      params = params_template(:date_of_transaction, {from: (Date.today - 2).as_json, to: Date.today.as_json})
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      date_range = (params[:transaction_filters][:date_of_transaction][:from]..params[:transaction_filters][:date_of_transaction][:to])
      raw_data = ReadModels::Transactions::TransactionProjection.where(date_of_transaction: date_range).to_json 
      expected = ::AllTransactionsSerializer.new(raw_data).serializable_hash.to_json
      expect(response.body).to eq(expected)
    end


    it 'filters with status combination' do 
      params = params_template(:status, %i[accepted pending])
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }

      accepted = ReadModels::Transactions::TransactionProjection.all.accepted 
      pending = ReadModels::Transactions::TransactionProjection.all.pending 
      raw_data = accepted + pending
      expected = ::AllTransactionsSerializer.new(raw_data).serializable_hash.to_json

      expect(response.body).eq( expected )
    end

    # TODO
    it 'filters with users' do 
      debtor = User.all.sample
      params = params_template(:users, [ debtor.id ])
 

      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      raw_data = ReadModels::Transactions::TransactionProjection.where(debtor_id: params[:transaction_filters][:debtors].map { |user| user.id } ).to_json 

      expect(response.body).to eq(expected)
    end

  end 

  context 'when regular user' do 
    context 'when filter by type' do 
      it 'gets borrow transactions' do
        params = params_template(:type, "borrow")
        get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + @access_token_2.token }

        raw_data = ReadModels::Transactions::TransactionProjection.where(debtor_id: @our_user.id).to_json
        expected = ::AllTransactionsSerializer.new(raw_data).serializable_hash.to_json
        expect(response.body).to eq(expected)
      end

      it 'gets lend transactions' do 
        params = { transaction_filters: { type: "lend" } }
        get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + @access_token_2.token }

        raw_data = ReadModels::Transactions::TransactionProjection.where(creditor_id: @our_user.id).to_json
        expected = ::AllTransactionsSerializer.new(raw_data).serializable_hash.to_json
        expect(response.body).to eq(expected)
      end
    end
  end

end