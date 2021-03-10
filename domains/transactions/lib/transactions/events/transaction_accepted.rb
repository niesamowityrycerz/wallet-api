module Transactions 
  module Events 
    class TransactionAccepted < Event 
      SCHEMA = {
        transaction_uid: String,
        status: Symbol
      }
    end
  end
end