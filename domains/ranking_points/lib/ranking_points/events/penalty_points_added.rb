module RankingPoints
  module Events
    class PenaltyPointsAdded < Event 
      SCHEMA = {
        debt_uid: String,
        penalty_points: Integer,
        debtor_id: Integer,
        warning_type_id: Integer,
        warning_uid: String,
        status: Symbol,
        due_money: Float
      }
    end
  end
end