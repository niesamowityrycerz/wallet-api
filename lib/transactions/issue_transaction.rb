module Transactions
  class IssueTransaction
    def initialize(creditor_id, debtor_ids, per_user_transaction)
      @creditor_id = creditor_id
      @per_user_transaction = per_user_transaction
      @debtor_ids = debtor_ids
    end


    def call
      Rails.configuration.command_bus.call(
        Transactions::Commands::IssueTransaction.new(
          {
            transaction_uid: SecureRandom.uuid,
            creditor_id: @creditor_id,
            debtor_id:   @debtor_ids.sample,
            amount:      rand(1.0..100.0).round(2),
            description: 'test',
            currency_id: Currency.find_by!(code: 'PLN').id,
            date_of_transaction: Date.today + rand(1..10) 
          }
        )
      )

    end
  end
end