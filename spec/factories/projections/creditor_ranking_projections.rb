FactoryBot.define do
  factory :creditor_ranking_projections, class: "ReadModels::CreditorRankingProjection" do
    creditor 
    trust_points         { 0 }
    credits_quantity     { 0 }
  end
end
