module Transactions 
  module Events 
    class TransactionAccepted < Event 
      SCHEMA = {
        transaction_uid: String,
        state: Symbol,
        expire_on: Date,
        debtor_id: Integer
      }
    end
  end
end