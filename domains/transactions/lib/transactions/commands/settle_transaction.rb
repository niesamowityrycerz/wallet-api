module Transactions
  module Commands 
    class SettleTransaction < Command
      SCHEMA = {
        transaction_uid: String
      }
    end
  end
end