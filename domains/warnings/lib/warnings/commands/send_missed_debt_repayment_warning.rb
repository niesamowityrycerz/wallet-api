module Warnings 
  module Commands 
    class SendMissedDebtRepaymentWarning < Command
      SCHEMA = {
        debt_uid: String,
        debtor_id: Integer
      }
    end
  end
end