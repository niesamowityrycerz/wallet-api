FactoryBot.define do 
  factory :user, aliases: [ :creditor ] do 
    email                 { Faker::Internet.email  }
    password              { 'password1'}
    password_confirmation { 'password1'}
  end
end