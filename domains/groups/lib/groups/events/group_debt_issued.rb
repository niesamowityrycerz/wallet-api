module Groups 
  module Events 
    class GroupDebtIssued < Event 
      SCHEMA = {
        issuer_id: Integer,
        recievers_ids: [[Integer]],
        description: String,
        total_amount: Float,
        due_money_per_reciever: Float,
        currency_id: Integer,
        date_of_transaction: [ :optional, Date ],
        group_debt: TrueClass,
        group_uid: String,
        state: Symbol
      }
    end
  end
end