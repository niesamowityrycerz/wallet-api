module Debts 
  module Events
    class DebtRejected < Event
      SCHEMA = {
        debt_uid: String,
        state: Symbol,
        reason_for_rejection: String 
      }
    end
  end
end