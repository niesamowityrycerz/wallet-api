module RankingPoints
  module Events 
    class TrustPointsAlloted < Event 
      SCHEMA = {
        transaction_uid: String,
        trust_points: Float,
        creditor_id: Integer,
        state: Symbol
      }
    end
  end
end