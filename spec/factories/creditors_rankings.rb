FactoryBot.define do
  factory :creditors_ranking, class: "WriteModels::CreditorsRanking" do
    creditor 
    trust_points         { 0 }
    credits_quantity { 0 }
  end
end
