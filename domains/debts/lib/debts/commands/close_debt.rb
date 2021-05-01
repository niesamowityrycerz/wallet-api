module Debts 
  module Commands
    class CloseDebt < Command
      SCHEMA = {
        debt_uid: String,
        reason_for_closing: [ :optional, String ]
      }
    end
  end
end