module Groups 
  module Commands 
    class AddGroupSettlementTerms < Command 
      SCHEMA = {
        group_uid: String,
        currency_id: Integer,
        transaction_expired_on: Date
      }
    end 
  end
end