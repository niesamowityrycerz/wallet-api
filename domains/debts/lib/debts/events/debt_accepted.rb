module Debts 
  module Events 
    class DebtAccepted < Event 
      SCHEMA = {
        debt_uid: String,
        state: Symbol,
        expire_on: Date,
        debtor_id: Integer
      }
    end
  end
end