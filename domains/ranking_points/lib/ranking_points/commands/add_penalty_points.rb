module RankingPoints
  module Commands
    class AddPenaltyPoints < Command 
      SCHEMA = {
        debt_uid: String,
        debtor_id: Integer,
        warning_type_id: Integer,
        warning_uid: String,
        due_money: Float
      }
    end
  end
end