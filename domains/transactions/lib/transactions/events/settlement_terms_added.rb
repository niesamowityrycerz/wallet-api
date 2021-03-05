module Transactions
  module Events 
    class SettlementTermsAdded < Event 
      SCHEMA = {
        transaction_uid: String,
        max_date_of_settlement: Date,
        repayment_type_id: Integer
      }
    end
  end
end