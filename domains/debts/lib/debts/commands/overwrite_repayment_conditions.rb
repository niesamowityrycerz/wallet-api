module Debts 
  module Commands 
    class OverwriteRepaymentConditions < Command 
      SCHEMA = {
        debt_uid: String,
        currency_id: Integer,
        maturity_in_days: Integer
      }
    end
  end
end