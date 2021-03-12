module Warnings
  module Events 
    class TransactionExpiredWarningSent < Event 
      SCHEMA = {
        transaction_uid: String,
        status: Symbol
      }
    end
  end
end