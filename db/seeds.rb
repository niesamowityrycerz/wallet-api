# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# User 
2.times do 
  User.create!(
    email: Faker::Internet.email,
    password: 'password1',
    password_confirmation: 'password1'
  )
end

# Currency
Currency.create!(name: 'Zloty', code: 'PLN')
Currency.create!(name: 'Euro',  code: 'EUR')
Currency.create!(name: 'US Dollar', code: 'USD')

# Settlement method
SettlementMethod.create!(name: 'one instalment')
SettlementMethod.create!(name: 'multiple instalments')

# repayment_conditions
creditor = User.first 
debtor   = User.second 
zloty = Currency.find_by!(name: 'Zloty')
one_instalment_method = SettlementMethod.find_by!(name: 'one instalment')

WriteModels::RepaymentCondition.create!(
  {
    maturity_in_days: rand(1..5),
    creditor_id: creditor.id,
    debtor_id:   debtor.id,
    currency_id: zloty.id,
    settlement_method_id: one_settlement_method.id,
  }
)

# warnings 
transaction_expired = WarningType.create(name: 'transaction expired')
user = User.first 
WriteModels::Warning.create(user_id: user.id, warning_type_id: transaction_expired.id)


