module Transactions
  module Events
    class TransactionSettled < Event 
      SCHEMA = {
        transaction_uid: String,
        date_of_settlement: Date,
        state: Symbol,
        debtor_id: Integer,
        creditor_id: Integer,
        amount: Float
      }
    end
  end
end