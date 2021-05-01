module Debts 
  module Commands 
    class RejectDebt < Command
      SCHEMA = {
        debt_uid: String,
        reason_for_rejection: String
      }
    end
  end
end