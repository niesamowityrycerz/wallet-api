module RankingPoints
  module Events 
    class CredibilityPointsAlloted < Event 
      SCHEMA = {
        debt_uid: String,
        credibility_points: Float,
        adjusted_credibility_points: Float,
        debtor_id: Integer,
        due_money: Float
      }
    end
  end
end