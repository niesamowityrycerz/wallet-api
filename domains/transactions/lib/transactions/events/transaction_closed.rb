module Transactions
  module Events
    class TransactionClosed < Event 
      SCHEMA = {
        transaction_uid: String,
        status: Symbol,
        reason_for_closing: [ :optional, String ]
      }
    end
  end
end