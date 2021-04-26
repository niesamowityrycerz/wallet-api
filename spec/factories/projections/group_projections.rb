FactoryBot.define do 
  factory :group_projection, class: ReadModels::Groups::GroupProjection do 
    from        { Date.today } 
    to          { Date.today + rand(5..10) }
    name        { Faker::Address.country + "_#{rand(1..100)}" }
    state       { :init }

    trait :lasting_10_days do 
      to { Date.today + 10 }
    end

  end
end