module Debts 
  module Events 
    class DebtAccepted < Event 
      SCHEMA = {
        debt_uid: String,
        status: Symbol,
        expire_on: Date,
        debtor_id: Integer
      }
    end
  end
end