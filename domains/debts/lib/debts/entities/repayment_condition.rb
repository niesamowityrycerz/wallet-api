module Debts  
  module Entities
    class RepaymentCondition

      attr_reader :maturity_in_days, :currency_id

      def initialize(params)
        @creditor_id = params[:creditor_id]
        @currency_id = params[:currency_id]
        @maturity_in_days = params[:maturity_in_days]
      end

      def creditor_conditions
        {
          maturity_in_days: maturity_in_days,
          currency_id: currency_id,
          creditor_id: @creditor_id
        }
      end

      def currency_allowed?(settlement_curency_id)
        currency_id == settlement_curency_id
      end
      
    end
  end
end