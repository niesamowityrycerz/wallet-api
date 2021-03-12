module TrustPoints
  module Commands 
    class CalculateTrustPoints < Command 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer,
        due_money: Float
      }
    end
  end
end