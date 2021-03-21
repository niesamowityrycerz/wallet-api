module Warnings 
  module Commands 
    class SendTransactionExpiredWarning < Command
      SCHEMA = {
        transaction_uid: String,
        debtor_id: Integer
      }
    end
  end
end