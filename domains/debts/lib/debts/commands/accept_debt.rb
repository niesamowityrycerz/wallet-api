module Debts 
  module Commands 
    class AcceptDebt < Command 
      SCHEMA = {
        debt_uid: String
      }
    end
  end
end