module Transactions
  module Commands
    class IssueTransaction < Command 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer,
        debtor_id: Integer,
        amount: Float,
        description: String,
        currency_id: Integer,
        date_of_transaction: [ Date, NilClass ],
      }

    end
  end
end