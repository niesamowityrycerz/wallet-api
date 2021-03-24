module Transactions
  module Events
    class TransactionRejected < Event
      SCHEMA = {
        transaction_uid: String,
        status: Symbol,
        reason_for_rejection: String 
      }
    end
  end
end