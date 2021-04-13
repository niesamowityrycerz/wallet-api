module Transactions
  module Events
    class TransactionClosed < Event 
      SCHEMA = {
        transaction_uid: String,
        state: Symbol,
        reason_for_closing: [ :optional, String ],
        creditor_id: Integer
      }
    end
  end
end