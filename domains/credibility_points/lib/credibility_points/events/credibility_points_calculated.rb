module CredibilityPoints
  module Events
    class CredibilityPointsCalculated < Event 
      SCHEMA = {
        credibility_points: Float,
        debtor_id: Integer,
        transaction_uid: String,
        due_money: Float,
        status: Symbol
      }
    end
  end
end