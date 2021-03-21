module Warnings
  module Events 
    class TransactionExpiredWarningSent < Event 
      SCHEMA = {
        transaction_uid: String,
        status: Symbol,
        user_id: Integer,
        warning_type_id: Integer,
        warning_uid: String
      }
    end
  end
end