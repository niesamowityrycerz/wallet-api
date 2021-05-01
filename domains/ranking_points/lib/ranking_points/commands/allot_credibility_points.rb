module RankingPoints
  module Commands 
    class AllotCredibilityPoints < Command 
      SCHEMA = {
        debt_uid: String,  
        debtor_id: Integer,
        due_money: Float,
        expire_on: Date
      }
    end
  end
end