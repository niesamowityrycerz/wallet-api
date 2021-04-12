module Transactions
  module Events 
    class SettlementTermsAdded < Event 
      SCHEMA = {
        transaction_uid: String,
        anticipated_date_of_settlement: Date,
        state: Symbol,
        debtor_id: Integer
      }
    end
  end
end