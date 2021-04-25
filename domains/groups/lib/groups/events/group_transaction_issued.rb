module Groups 
  module Events 
    class GroupTransactionIssued < Event 
      SCHEMA = {
        creditor_id: Integer,
        debtors_ids: [[Integer]],
        description: String,
        amount: Float,
        currency_id: Integer,
        date_of_transaction: [ :optional, Date ],
        group_transaction: TrueClass,
        group_uid: String,
        state: Symbol
      }
    end
  end
end