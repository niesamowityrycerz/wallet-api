FactoryBot.define do 
  factory :debtor_ranking_projection, class: "ReadModels::Rankings::DebtorRankingProjection" do 
    debtor
    adjusted_credibility_points { 0 }
    debts_quantity         { 0 }
  end
end