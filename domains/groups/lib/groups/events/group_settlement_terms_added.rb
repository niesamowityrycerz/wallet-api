module Groups 
  module Events 
    class GroupSettlementTermsAdded < Event 
      SCHEMA = {
        currency_id: Integer,
        debt_repayment_valid_till: Date,
        status: Symbol
      }
    end
  end
end