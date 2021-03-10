module TransactionPoints
  module Events
    class CredibilityPointsCalculated < Event 
      SCHEMA = {
        transaction_uid: String,
        credibility_points: Float
      }
    end
  end
end