module TransactionPoints
  module Events
    class FaithPointsCalculated < Event 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer,
        faith_points: Float
      }
    end
  end
end