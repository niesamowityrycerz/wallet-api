module Warnings
  module Events 
    class MissedDebtRepaymentWarningSent < Event 
      SCHEMA = {
        debt_uid: String,
        status: Symbol,
        user_id: Integer,
        warning_type_id: Integer,
        warning_uid: String
      }
    end
  end
end