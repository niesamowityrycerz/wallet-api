module TransactionPoints
  module Commands 
    class CalculateFaithPoints < Command 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer,
        due_money: Float
      }
    end
  end
end