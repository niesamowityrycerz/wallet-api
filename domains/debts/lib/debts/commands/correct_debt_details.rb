module Debts 
  module Commands
    class CorrectDebtDetails < Command 
      SCHEMA = {
        debt_uid: String,
        amount: [ :optional, Float ],
        description: [ :optional, String ],
        currency_id: [ :optional, Integer ],
        date_of_transaction: [ :optional, Date ]
      }
    end
  end
end