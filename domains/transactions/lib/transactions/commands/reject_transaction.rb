module Transactions
  module Commands 
    class RejectTransaction < Command
      SCHEMA = {
        transaction_uid: String,
        reason_for_closing: String
      }
    end
  end
end