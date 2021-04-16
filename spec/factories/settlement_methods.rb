FactoryBot.define do 
  factory :settlement_method do 
    name { 'one instalment' }

    trait :multiple_instalments do 
      name { 'many instalments' }
    end  
    
  end
end