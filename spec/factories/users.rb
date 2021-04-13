FactoryBot.define do 
  factory :user, aliases: [ :creditor, :debtor ] do 
    email                 { Faker::Internet.email  }
    password              { 'password1' }
    password_confirmation { 'password1' }
    username              { Faker::Internet.username }

    trait :admin do 
      username { 'ADMIN' }
      admin    { true }
    end

    trait :with_ranking_position do 
      after(:create) do |user|
         create(:debtors_ranking, debtor: user, debt_transactions: 1, adjusted_credibility_points: 10)
         create(:creditors_ranking, creditor: user, credit_transactions: 1, trust_points: 10)
      end 
    end
    
  end 
end