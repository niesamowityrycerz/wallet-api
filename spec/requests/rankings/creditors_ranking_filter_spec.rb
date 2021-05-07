require 'rails_helper'

RSpec.describe 'Creditors ranking filter spec', type: :request do 

  let!(:users)                  { create_list(:user, 100, :with_creditors_ranking) }

  context "when no filters" do 
    it 'checks ranking positions' do 
      get "/api/v1/ranking/creditors"
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      should_be_displayed = WriteModels::Rankings::CreditorsRanking.order("trust_points, DESC").to_json
      binding.pry 
    end
  end


end