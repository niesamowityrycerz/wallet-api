module Warnings 
  module Commands 
    class SendTransactionExpiredWarning < Command
      SCHEMA = {
        transaction_uid: String
      }
    end
  end
end