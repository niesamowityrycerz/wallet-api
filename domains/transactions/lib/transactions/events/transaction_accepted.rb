module Transactions 
  module Events 
    class TransactionAccepted < Event 
      SCHEMA = {
        transaction_uid: String,
        state: Symbol
      }
    end
  end
end