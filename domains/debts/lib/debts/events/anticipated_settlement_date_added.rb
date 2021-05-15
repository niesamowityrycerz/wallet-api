module Debts 
  module Events 
    class AnticipatedSettlementDateAdded < Event 
      SCHEMA = {
        debt_uid: String,
        anticipated_date_of_settlement: Date,
        status: Symbol
      }
    end
  end
end