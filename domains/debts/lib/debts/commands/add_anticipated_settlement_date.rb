module Debts 
  module Commands 
    class AddAnticipatedSettlementDate < Command 
      SCHEMA = {
        debt_uid: String,
        anticipated_date_of_settlement: Date
      }
    end
  end
end