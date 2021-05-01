module Debts 
  module Events
    class DebtSettled < Event 
      SCHEMA = {
        debt_uid: String,
        date_of_settlement: Date,
        state: Symbol,
        debtor_id: Integer,
        creditor_id: Integer,
        amount: Float,
        expire_on: Date
      }
    end
  end
end