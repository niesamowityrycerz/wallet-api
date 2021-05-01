module Debts 
  module Commands 
    class CheckOutDebtDetails < Command
      SCHEMA = {
        debt_uid: String,
        doubts: String
      }
    end
  end
end