FactoryBot.define do 
  factory :user, aliases: [ :creditor, :debtor ] do 
    email                 { Faker::Internet.email  }
    password              { 'password1' }
    password_confirmation { 'password1' }
    username              { Faker::Internet.username }

    trait :admin do 
      admin    { true }
    end

    trait :with_some_ranking_data do 
      after(:create) do |user|
        creditor_ranking_position = ReadModels::Rankings::CreditorRankingProjection.find_by!(creditor_id: user.id)
        creditor_ranking_position.update!({
          trust_points: rand(10.0..100.0),
          credits_quantity: rand(1..10)
        })

        debtor_ranking_position = ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: user.id)
        debtor_ranking_position.update!({
          adjusted_credibility_points: rand(10.0..100.0),
          debts_quantity: rand(1..10)
        })
      end 
    end

    trait :with_repayment_conditions do 
      after(:create) do |user|
        create(:repayment_condition, :maturity_in_one_year, creditor: user, currency: Currency.find_or_create_by!(name: 'Polski złoty', code: 'PLN'))
      end
    end

  end 
end