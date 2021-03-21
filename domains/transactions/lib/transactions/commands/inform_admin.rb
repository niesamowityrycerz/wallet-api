module Transactions 
  module Commands 
    class InformAdmin < Command 
      SCHEMA = {
        transaction_uid: String, 
        message_to_admin: String 
      }
    end
  end
end