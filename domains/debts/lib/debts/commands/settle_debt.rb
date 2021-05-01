module Debts 
  module Commands 
    class SettleDebt < Command
      SCHEMA = {
        debt_uid: String
      }
    end
  end
end