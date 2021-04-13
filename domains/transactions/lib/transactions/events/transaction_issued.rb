module Transactions 
  module Events 
    class TransactionIssued < Event
      SCHEMA = {
        creditor_id: Integer,
        debtor_id: Integer,
        transaction_uid: String,
        amount: Float,
        description: String,
        currency_id: Integer,
        date_of_transaction: [ :optional, Date ],
        max_date_of_settlement: Date,
        settlement_method_id: Integer,
        state: Symbol
      }
    end
  end
end