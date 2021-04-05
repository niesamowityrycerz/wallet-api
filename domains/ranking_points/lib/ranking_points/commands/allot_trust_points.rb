module RankingPoints
  module Commands 
    class AllotTrustPoints < Command 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer
      }
    end
  end
end