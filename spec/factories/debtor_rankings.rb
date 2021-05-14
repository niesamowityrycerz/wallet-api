FactoryBot.define do 
  factory :debtor_ranking, class: "ReadModels::Rankings::DebtorRanking" do 
    debtor
    adjusted_credibility_points { 0 }
    debts_quantity         { 0 }
  end
end