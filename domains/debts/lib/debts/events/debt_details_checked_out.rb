module Debts 
  module Events 
    class DebtDetailsCheckedOut < Event 
      SCHEMA = {
        debt_uid: String,
        doubts: String
      }
    end
  end
end