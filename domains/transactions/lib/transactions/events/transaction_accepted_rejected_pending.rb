module Transactions 
  module Events 
    class TransactionAcceptedRejectedPending < Event 
      SCHEMA = {
        transaction_uid: String,
        status: Symbol
      }
    end
  end
end