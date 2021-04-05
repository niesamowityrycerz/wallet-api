module RankingPoints
  module Commands 
    class AllotCredibilityPoints < Command 
      SCHEMA = {
        transaction_uid: String,  
        debtor_id: Integer,
        due_money: Float
      }
    end
  end
end