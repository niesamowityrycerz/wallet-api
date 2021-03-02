module Transactions 
  module Events 
    class TransactionIssued < Event
      SCHEMA = {
        issuer_uid: String,
        borrower_name: String,
        issuer_id: Integer,
        amount: Integer,
        transaction_uid: String,
        description: String
      }
    end
  end
end