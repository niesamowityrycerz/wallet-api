FactoryBot.define do 
  factory :user, aliases: [ :creditor, :debtor ] do 
    email                 { Faker::Internet.email  }
    password              { 'password1' }
    password_confirmation { 'password1' }
    username              { Faker::Internet.username }

    trait :admin do 
      admin    { true }
    end

    trait :with_ranking_position do 
      after(:create) do |user|
         create(:debtors_ranking, debtor: user, debts_quantity: 1, adjusted_credibility_points: 10)
         create(:creditors_ranking, creditor: user, credits_quantity: 1, trust_points: 10)
      end 
    end

    trait :with_repayment_conditions do 
      after(:create) do |user|
        create(:repayment_condition, :maturity_in_one_year, creditor: user, currency: Currency.find_or_create_by!(name: 'Polski złoty', code: 'PLN'))
      end
    end
    
  end 
end