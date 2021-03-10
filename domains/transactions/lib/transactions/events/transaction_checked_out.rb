module Transactions 
  module Events 
    class TransactionCheckedOut < Event 
      SCHEMA = {
        transaction_uid: String,
        doubts: String
      }
    end
  end
end