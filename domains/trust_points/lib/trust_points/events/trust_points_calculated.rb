module TrustPoints
  module Events
    class TrustPointsCalculated < Event 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer,
        trust_points: Float,
        status: Symbol
      }
    end
  end
end