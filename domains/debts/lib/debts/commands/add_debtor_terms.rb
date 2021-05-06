module Debts 
  module Commands 
    class AddDebtorTerms < Command 
      SCHEMA = {
        debt_uid: String,
        anticipated_date_of_settlement: Date
      }
    end
  end
end