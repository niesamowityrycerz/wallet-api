module TrustPoints
  module Events 
    class TrustPointsAlloted < Event 
      SCHEMA = {
        transaction_uid: String,
        trust_points: Float,
        creditor_id: Integer,
        status: Symbol
      }
    end
  end
end