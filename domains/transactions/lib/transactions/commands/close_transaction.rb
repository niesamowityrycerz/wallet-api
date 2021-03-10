module Transactions
  module Commands
    class CloseTransaction < Command
      SCHEMA = {
        transaction_uid: String,
        reason_for_closing: [ :optional, String ]
      }
    end
  end
end