RSpec.shared_examples 'on filtering with status' do |status|


  let(:admin)                     { create(:user, :admin) }
  let(:application)               { create(:application) }
  let(:access_token)              { create(:access_token, application: application, resource_owner_id: admin.id) }

  before(:all) do 
    per_user_transaction = 5
    users = create_list(:user, 10)

    users.each do |creditor|
      debtor_ids = users.map { |user| user.id } 
      debtor_ids.select! { |id| id != creditor.id }
      create_list(:transaction_projection, 5, creditor_id: creditor.id, debtor_id: debtor_ids.sample, status: %i[rejected accepted pending].sample)
    end
  end

  context "when #{status}" do 
    it "checks response" do 
      params = {
        transaction_filters: {
          status: [status]
        }
      }
      
      get "/api/v1/transactions", params: params, headers: { 'Authorization': 'Bearer ' + access_token.token }
      expected = ReadModels::Transactions::TransactionProjection.where(status: status).to_json 
      expect(response.body).to eq(expected)
    end
  end 
end