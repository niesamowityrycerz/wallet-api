module Transactions
  module Events 
    class DebtorTermsAdded < Event 
      SCHEMA = {
        transaction_uid: String,
        anticipated_date_of_settlement: Date,
        state: Symbol,
        debtor_settlement_method_id: Integer
      }
    end
  end
end