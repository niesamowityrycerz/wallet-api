module Debts 
  module Events 
    class RepaymentConditionsOverwrote < Event 
      SCHEMA = {
        debt_uid: String,
        max_date_of_settlement: Date,
        currency_id: Integer,
        maturity_in_days: Integer
      }
    end
  end
end