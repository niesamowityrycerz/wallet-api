FactoryBot.define do
  factory :creditors_ranking, class: "WriteModels::CreditorsRanking" do
    creditor 
    trust_points         { 0 }
    credit_transactions { 0 }
  end
end
