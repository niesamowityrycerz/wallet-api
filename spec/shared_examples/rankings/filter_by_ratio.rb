RSpec.shared_examples "Filter by ratio", type: :request do |option|

  let!(:users)                  { create_list(:user, 100, :with_some_ranking_data) }

  before(:each) do 
    @mapper = {
      highest_to_lowest: "DESC",
      lowest_to_highest: "ASC"
    }
  end

  context 'when ratio' do 
    it "filters from #{option}" do
      query_params = { filters: { ratio: option } }
      get "/api/v1/ranking/creditors", params: query_params

      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      displayed_credits_quantity = parsed_body["data"].collect { |record| record["attributes"]["ratio"] }
      base_data = ReadModels::Rankings::CreditorRanking.order("ratio #{@mapper[option]}" )

      to_be_displayed = (base_data.collect {|record| record.ratio.to_s }).first(25)
      expect(displayed_credits_quantity).to eq(to_be_displayed)
    end
  end
end