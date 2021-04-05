module Transactions
  module Commands 
    class SettleTransaction < Command
      SCHEMA = {
        transaction_uid: String,
        date_of_settlement: Date
      }
    end
  end
end