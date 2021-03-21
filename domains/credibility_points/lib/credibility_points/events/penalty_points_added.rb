module CredibilityPoints
  module Events
    class PenaltyPointsAdded < Event 
      SCHEMA = {
        transaction_uid: String,
        penalty_points: Integer,
        debtor_id: Integer,
        warning_type_id: Integer,
        warning_uid: String
      }
    end
  end
end