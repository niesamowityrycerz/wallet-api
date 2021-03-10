module Transactions
  module Commands 
    class RejectTransaction < Command
      SCHEMA = {
        transaction_uid: String
      }
    end
  end
end