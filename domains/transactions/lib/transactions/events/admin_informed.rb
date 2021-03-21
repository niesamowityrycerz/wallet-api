module Transactions 
  module Events 
    class AdminInformed < Event
      SCHEMA = {
        transaction_uid: String,
        message_to_admin: String,
        status: Symbol
      }
    end
  end
end