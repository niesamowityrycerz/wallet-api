module Groups 
  module Events 
    class GroupSettlementTermsAdded < Event 
      SCHEMA = {
        currency_id: Integer,
        debt_repayment_valid_till: Date,
        state: Symbol
      }
    end
  end
end