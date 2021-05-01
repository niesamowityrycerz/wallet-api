module RankingPoints
  module Events 
    class TrustPointsAlloted < Event 
      SCHEMA = {
        debt_uid: String,
        trust_points: Float,
        creditor_id: Integer,
        state: Symbol
      }
    end
  end
end