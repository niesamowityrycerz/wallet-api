module Debts 
  module Events
    class DebtDetailsCorrected < Event 
      SCHEMA = {
        debt_uid: String,
        amount: [ :optional, Float ],
        description: [ :optional, String ],
        currency_id: [ :optional, Integer ],
        date_of_transaction: [ :optional, Date ],
        state: Symbol
      }
    end
  end
end