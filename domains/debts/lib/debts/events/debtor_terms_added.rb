module Debts 
  module Events 
    class DebtorTermsAdded < Event 
      SCHEMA = {
        debt_uid: String,
        anticipated_date_of_settlement: Date,
        state: Symbol
      }
    end
  end
end