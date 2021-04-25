module Groups 
  module Events 
    class GroupSettlementTermsAdded < Event 
      SCHEMA = {
        currency_id: Integer,
        transaction_expired_on: Date,
        state: Symbol
      }
    end
  end
end