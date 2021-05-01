module Groups 
  module Commands 
    class AddGroupSettlementTerms < Command 
      SCHEMA = {
        group_uid: String,
        currency_id: Integer,
        debt_repayment_valid_till: Date
      }
    end 
  end
end