FactoryBot.define do 
  factory :debtors_ranking, class: "WriteModels::DebtorsRanking" do 
    debtor
    adjusted_credibility_points { 0 }
    debts_quantity         { 0 }
  end
end