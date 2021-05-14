# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Delete all record from all tables 
# Currency.delete_all
# User.delete_all
# SettlementMethod.delete_all
# WriteModels::RepaymentCondition.delete_all
# ReadModels::Transactions::TransactionProjection.delete_all

# Create my own OAuth Application
# create Doorkeeper::Application in console 
# wallet_app = Doorkeeper::Application.create(name: "Wallet Development Client", redirect_uri: "", scopes: "")


# Currencies
start = Time.now 
Currency.create!(name: 'Zloty', code: 'PLN')
Currency.create!(name: 'Euro',  code: 'EUR')
Currency.create!(name: 'US Dollar', code: 'USD')

# Waring types
WarningType.create(name: 'missed debt repayment')


Users::RunAll.new(users_quantity=10).call
Debts::RunAll.new(per_user_debt=5).call(accept_q=10, reject_q=10, settle=10, checkout=10)
Warnings::RunAll.new(warnings_q=15)
Groups::RunAll.call(groups_q=5)

User.create({
  username: "ADMIN",
  email: 'admin@wp.pl',
  password: 'password1',
  password_confirmation: 'password1',
  admin: true
})

::Debts::ManyDebtsAndCreditsBetweenTwoUsers.new(user_1_id=1,user_2_id=2).call

User.all.each do |user|
  100.times do |i|
    user.posts.create(body: "test_#{user.id}_#{i}")
  end 
end

stop = Time.now 
puts stop - start 





