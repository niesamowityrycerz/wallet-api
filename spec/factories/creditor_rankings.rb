FactoryBot.define do
  factory :creditor_rankings, class: "WriteModels::CreditorsRanking" do
    creditor 
    trust_points         { 0 }
    credits_quantity     { 0 }
  end
end
