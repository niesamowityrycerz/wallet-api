module Transactions
  module Commands 
    class AddSettlementTerms < Command 
      SCHEMA = {
        transaction_uid: String,
        debtor_id: Integer,
        max_date_of_settlement: Date,
        debtor_settlement_method_id: Integer,
        currency_id: Integer
      }
    end
  end
end