module Debts 
  module Events
    class DebtClosed < Event 
      SCHEMA = {
        debt_uid: String,
        status: Symbol,
        reason_for_closing: [ :optional, String ],
        creditor_id: Integer
      }
    end
  end
end