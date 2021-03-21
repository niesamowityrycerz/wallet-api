
# Transaction Start 
transaction_uid = SecureRandom.uuid
issue_tran_params = { transaction_uid: transaction_uid, creditor_id: User.first.id, 
                      debtor_id: User.second.id, amount: 10.0, currency_id: Currency.first.id,
                      date_of_transaction: Date.today, description: 'hwdp' }
Rails.configuration.command_bus.call(Transactions::Commands::IssueTransaction.send(issue_tran_params))

# add settlement terms 
settlement_terms_params = { transaction_uid: transaction_uid, debtor_id: User.second.id, max_date_of_settlement: Date.today + rand(1..9).day,
                            settlement_method_id: SettlementMethod.first.id,currency_id: Currency.first.id }
Rails.configuration.command_bus.call(Transactions::Commands::AddSettlementTerms.new(settlement_terms_params))


# settle transaction 

settle_params = { transaction_uid: transaction_uid, date_of_settlement: Date.today, amount: 10.0 , debtor_id: User.second.id }
Rails.configuration.command_bus.call(Transactions::Commands::AddSettlementTerms.new(settle_params))
