module Transactions
  module Events
    class TransactionRejected < Event
      SCHEMA = {
        transaction_uid: String,
        status: Symbol
      }
    end
  end
end