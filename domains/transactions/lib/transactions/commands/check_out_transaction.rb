module Transactions
  module Commands 
    class CheckOutTransaction < Command
      SCHEMA = {
        transaction_uid: String,
        doubts: String
      }
    end
  end
end