module Transactions
  module Commands
    class IssueTransaction < Command 
      SCHEMA = {
        issuer_id: Integer,
        issuer_uid: String,
        borrower_name: String,
        amount: Integer,
        description: String
      }

    end
  end
end