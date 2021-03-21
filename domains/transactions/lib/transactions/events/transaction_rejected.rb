module Transactions
  module Events
    class TransactionRejected < Event
      SCHEMA = {
        transaction_uid: String,
        status: Symbol,
        reason_for_closing: String 
      }
    end
  end
end