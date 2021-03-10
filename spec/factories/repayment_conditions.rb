FactoryBot.define do 
  factory :repayment_condition, class: WriteModels::RepaymentCondition do 
    creditor 
    currency 
    settlement_method

    trait :maturity_in_10_days do 
      maturity_in_days  { 10 }
    end

    trait :maturity_in_20_days do 
      maturity_in_days  { rand(11..20) }
    end
  end
end