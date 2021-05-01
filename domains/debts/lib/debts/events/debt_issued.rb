module Debts  
  module Events 
    class DebtIssued < Event
      SCHEMA = {
        creditor_id: Integer,
        debtor_id: Integer,
        debt_uid: String,
        amount: Float,
        description: String,
        currency_id: Integer,
        date_of_transaction: [ :optional, Date ],
        max_date_of_settlement: Date,
        settlement_method_id: [ :optional, Integer ],
        state: Symbol,
        group_debt: [ :optional, TrueClass],
        group_uid: [ :optional, String ]
      }
    end
  end
end