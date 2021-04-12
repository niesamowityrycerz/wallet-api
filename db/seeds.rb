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
# "2xODT1L_HhxEd5cZCJqAsMRXBDJ7y-AgfJlOKFMmzmM" secret -> client_secret 
# "C0NMy86Pb4VR7kmZP5YOAS_oscJpGgRmL3_uUCmdPqY" uid -> client_uid



# Currencies
Currency.create!(name: 'Zloty', code: 'PLN')
Currency.create!(name: 'Euro',  code: 'EUR')
Currency.create!(name: 'US Dollar', code: 'USD')

# Settlement methods
SettlementMethod.create!(name: 'one instalment')
SettlementMethod.create!(name: 'multiple instalments')

# admin 
User.create!(username: "admin", email: "admin@wp.pl", password: "password1", password_confirmation: "password1", admin: true)


Transactions::RunAll.new(users=10, per_user_transaction=5).call

Warnings::RunAll.new()


# warnings 
transaction_expired = WarningType.create(name: 'transaction expired')
user = User.first 
WriteModels::Warning.create(user_id: user.id, warning_type_id: transaction_expired.id)


