module Debts 
  module Events
    class DebtClosed < Event 
      SCHEMA = {
        debt_uid: String,
        state: Symbol,
        reason_for_closing: [ :optional, String ],
        creditor_id: Integer
      }
    end
  end
end