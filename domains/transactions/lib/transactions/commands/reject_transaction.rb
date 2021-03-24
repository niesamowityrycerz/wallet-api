module Transactions
  module Commands 
    class RejectTransaction < Command
      SCHEMA = {
        transaction_uid: String,
        reason_for_rejection: String
      }
    end
  end
end