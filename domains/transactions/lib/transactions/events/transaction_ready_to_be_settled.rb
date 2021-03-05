module Transactions 
  module Events 
    class TransactionReadyToBeSettled < Event 
      SCHEMA = {
        transaction_uid: Integer,
        status: Symbol
      }
    end
  end
end