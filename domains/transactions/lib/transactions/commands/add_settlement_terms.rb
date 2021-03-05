module Transactions
  module Commands 
    class AddSettlementTerms < Command 
      SCHEMA = {
        transaction_uid: String,
        creditor_id: Integer,
        debtor_id: Integer,
        max_date_of_settlement: Date,
        repayment_type_id: Integer,
        currency_id: Integer
      }
    end
  end
end