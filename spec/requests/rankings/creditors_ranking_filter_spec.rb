require 'rails_helper'
require 'shared_examples/rankings/filter_by_credits_quantity'
require 'shared_examples/rankings/filter_by_ratio'

RSpec.describe 'Creditors ranking filter spec', type: :request do 

  let!(:users)                  { create_list(:user, 100, :with_some_ranking_data) }

  it_should_behave_like "Filter by credits quantity", :most_to_least
  it_should_behave_like "Filter by credits quantity", :least_to_most 

  it_should_behave_like "Filter by ratio", :highest_to_lowest
  it_should_behave_like "Filter by ratio", :lowest_to_highest

  context "when no filters" do 
    it 'checks displayed ranking positions' do 
      get "/api/v1/ranking/creditors"
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      displayed_trust_points = parsed_body["data"].collect { |record| record["attributes"]["trust_points"] }
      displayed_usernames = parsed_body["data"].collect { |record| record["attributes"]["creditor"] }
      displayed_ratio = parsed_body["data"].collect { |record| record["attributes"]["ratio"] }

      base_data = ReaModels::Rankings::CreditorRanking.order("ratio DESC").page(0)
      to_be_displayed = { trust_points: [], usernames: [], ratio: [] }
      base_data.each do |position|
        to_be_displayed[:trust_points] << position.trust_points
        to_be_displayed[:usernames] << User.find_by!(id: position.creditor_id).username
        to_be_displayed[:ratio] << position.ratio.to_s
      end

      expect(displayed_trust_points).to eq(to_be_displayed[:trust_points])
      expect(displayed_usernames).to eq(to_be_displayed[:usernames])
      expect(displayed_ratio).to eq(to_be_displayed[:ratio])
    end
  end

  context 'when trust points filter' do 
    it 'checks displayed ranking positions' do 
      query_params = {
        filters: {
          trust_points: {
            min: 50,
            max: 100
          }
        }
      }
      get "/api/v1/ranking/creditors", params: query_params

      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      displayed_trust_points = parsed_body["data"].collect { |record| record["attributes"]["trust_points"] }
      base_data = ReaModels::Rankings::CreditorRanking.where("trust_points <= ? AND trust_points >= ?", query_params[:filters][:trust_points][:max], query_params[:filters][:trust_points][:min] )
      trust_points_to_be_displayed = base_data.collect { |record| record.trust_points }

      expect(displayed_trust_points - trust_points_to_be_displayed).to eq([])

    end
  end

  context "when filter by creditors" do 
    it 'checks displayed ranking positions' do 
      query_params = {
        filters: {
          creditors_ids: User.ids.sample(3) 
        }
      }
      get "/api/v1/ranking/creditors", params: query_params
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      binding.pry
    end
  end
end