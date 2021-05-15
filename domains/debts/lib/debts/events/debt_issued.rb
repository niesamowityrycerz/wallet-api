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
        group_uid: [ :optional, String ]
      }
    end
  end
end