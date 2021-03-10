module Transactions
  module Events 
    class CreditorInformed < Event 
      SCHEMA = {
        transaction_uid: String,
        creditor_informed: TrueClass
      }
    end
  end
end