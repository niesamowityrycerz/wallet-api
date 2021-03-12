module CredibilityPoints
  module Events
    class CredibilityPointsCalculated < Event 
      SCHEMA = {
        transaction_uid: String,
        credibility_points: Float,
        debtor_id: Integer,
        status: Symbol
      }
    end
  end
end