module Transactions 
  module Entities
    class RepaymentCondition

      attr_reader :maturity_in_days, :settlement_method_id, :currency_id
      # attr_accessor :created_at


      def initialize(params)
        @creditor_id = params[:creditor_id]
        @currency_id = params[:currency_id]
        @maturity_in_days = params[:maturity_in_days]
        @settlement_method_id = params[:settlement_method_id]
      end

      def creditor_conditions
        {
          maturity_in_days: @maturity_in_days,
          currency_id: @currency_id,
          settlement_method_id: @settlement_method_id,
          creditor_id: @creditor_id
        }
      end

      def maturity_date_valid?(max_date_of_settlement, date_of_placement, maturity)
        date_of_placement + maturity.day >= max_date_of_settlement
      end

      def settlement_method_allowed?(debtor_method_id)
        if debtor_method_id == settlement_method_id
          true 
        else  
          false 
        end
      end

      def currency_allowed?(settlement_curency_id)
        currency_id == settlement_curency_id
      end


      
    end
  end
end