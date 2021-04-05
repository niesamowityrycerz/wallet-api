module Transactions
  module Events
    class TransactionRejected < Event
      SCHEMA = {
        transaction_uid: String,
        state: Symbol,
        reason_for_rejection: String 
      }
    end
  end
end