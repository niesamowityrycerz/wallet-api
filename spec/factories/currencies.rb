FactoryBot.define do 
  factory :currency do 
    name { 'Złoty' }
    code { 'PLN' }

    trait :euro do 
      name { 'Euro' }
      code { 'EUR' }
    end

    trait :us_dollar do 
      name { 'US Dollar' }
      code { 'USD' }
    end
  end
end