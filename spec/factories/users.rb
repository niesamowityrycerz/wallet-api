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
    
  end 
end