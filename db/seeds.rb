# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create my own OAuth Application
# create Doorkeeper::Application in console 
# wallet_app = Doorkeeper::Application.create(name: "Wallet-api", redirect_uri: "", scopes: "")


# Currencies
start = Time.now 
Currency.create!(name: 'Zloty', code: 'PLN')
Currency.create!(name: 'Euro',  code: 'EUR')
Currency.create!(name: 'US Dollar', code: 'USD')

# Warning types
WarningType.create(name: 'missed debt repayment')


Users::RunAll.new(users_quantity=40).call
Debts::RunAll.new(per_user_debt=5).call(accept_q=10, reject_q=10, settle=10, checkout=10)
Warnings::RunAll.new(warnings_q=15)
Groups::RunAll.call(groups_q=20, accept_q=10, reject_q=10) # accept_q + reject_q >! groups_q


User.create({
  username: "ADMIN",
  email: 'admin@wp.pl',
  password: 'password1',
  password_confirmation: 'password1',
  admin: true
})

::Debts::ManyDebtsAndCreditsBetweenTwoUsers.new(user_1_id=1,user_2_id=2).call


stop = Time.now 
puts stop - start 





