module TrustPoints
  module Commands 
    class AllotTrustPoints < Command 
      SCHEMA = {
        transaction_uid: String
      }
    end
  end
end