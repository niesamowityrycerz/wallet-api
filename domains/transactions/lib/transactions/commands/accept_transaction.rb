module Transactions 
  module Commands 
    class AcceptTransaction < Command 
      SCHEMA = {
        transaction_uid: String
      }
    end
  end
end