module Transactions
  module Commands 
    class SettleTransaction < Command
      SCHEMA = {
        transaction_uid: String,
        amount: Float,
        date_of_settlement: Date,
        debtor_id: Integer
      }
    end
  end
end