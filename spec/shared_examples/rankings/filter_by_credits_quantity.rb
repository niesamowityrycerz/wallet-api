RSpec.shared_examples "Filter by credits quantity", type: :request do |option|

  let!(:users)                  { create_list(:user, 100, :with_some_ranking_data) }

  before(:each) do 
    @mapper = {
      most_to_least: "DESC",
      least_to_most: "ASC"
    }
  end

  context 'when credits quantity' do 
    it "filters from #{option}" do
      query_params = { filters: { credits_quantity: option } }
      get "/api/v1/ranking/creditors", params: query_params

      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      displayed_credits_quantity = parsed_body["data"].collect { |record| record["attributes"]["credits_quantity"] }
      base_data = ReaModels::Rankings::CreditorRanking.order("credits_quantity #{@mapper[option]}" )

      to_be_displayed = (base_data.collect {|record| record.credits_quantity }).first(25)
      expect(displayed_credits_quantity).to eq(to_be_displayed)
    end
  end
end