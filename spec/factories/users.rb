FactoryBot.define do 
  factory :user, aliases: [ :creditor, :debtor ] do |i|
    email                 { Faker::Internet.email  }
    password              { 'password1' }
    password_confirmation { 'password1' }
    username              { "test_#{i}" }

    trait :admin do 
      username { 'ADMIN' }
      admin    { true }
    end
    
  end 
end