module CredibilityPoints
  module Commands 
    class AllotCredibilityPoints < Command 
      SCHEMA = {
        transaction_uid: String
      }
    end
  end
end