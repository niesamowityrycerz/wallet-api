module Transactions
  module Events
    class TransactionSettled < Event 
      SCHEMA = {
        transaction_uid: String,
        amount: Float,
        date_of_settlement: Date,
        status: Symbol,
        debtor_id: Integer,
        creditor_id: Integer
      }
    end
  end
end