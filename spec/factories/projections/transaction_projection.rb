FactoryBot.define do 
  factory :transaction_projection, class: ReadModels::Transactions::TransactionProjection do 
    transaction_uid           { SecureRandom.uuid }
    date_of_transaction       { Date.today - rand(1..5).day }
    amount                    { rand(1.0..1000.0).round(2) }
    description               { 'test' }
    status                    { :pending }
    
  end 
end