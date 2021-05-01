module RankingPoints
  module Commands 
    class AllotTrustPoints < Command 
      SCHEMA = {
        debt_uid: String,
        creditor_id: Integer
      }
    end
  end
end