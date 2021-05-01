module Debts 
  module Commands 
    class AddDebtorTerms < Command 
      SCHEMA = {
        debt_uid: String,
        anticipated_date_of_settlement: Date,
        debtor_settlement_method_id: Integer
      }
    end
  end
end