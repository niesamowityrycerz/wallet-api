module Debts 
  module Events
    class DebtRejected < Event
      SCHEMA = {
        debt_uid: String,
        status: Symbol,
        reason_for_rejection: String 
      }
    end
  end
end