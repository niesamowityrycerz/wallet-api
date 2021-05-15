module RankingPoints
  module Events 
    class TrustPointsAlloted < Event 
      SCHEMA = {
        debt_uid: String,
        trust_points: Float,
        creditor_id: Integer,
        status: Symbol
      }
    end
  end
end