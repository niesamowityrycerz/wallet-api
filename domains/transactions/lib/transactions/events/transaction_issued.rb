module Transactions 
  module Events 
    class TransactionIssued < Event
      SCHEMA = {
        creditor_id: Integer,
        debtor_id: Integer,
        transaction_uid: String,
        amount: Float,
        description: String,
        currency_id: Integer
      }
    end
  end
end