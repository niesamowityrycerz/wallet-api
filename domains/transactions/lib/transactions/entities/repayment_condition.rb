module Transactions 
  module Entities
    class RepaymentCondition

      attr_reader :maturity_in_days, :interest
      # attr_accessor :created_at


      def initialize(params)
        @creditor_id = params[:creditor_id]
        @interest = params[:interest]
        @currency_id = params[:currency_id]
        @maturity_in_days = params[:maturity]
        @repayment_type_id = params[:repayment_type_id]
        @created_at = nil 
      end

      def creditor_conditions
        {
          maturity_in_days: @maturity_in_days,
          interest: @interest,
          currency_id: @currency_id,
          repayment_type_id: @repayment_type_id,
          creditor_id: @creditor_id
        }
      end

      def maturity_date_valid?(max_date_of_settlement)
        # DO NOT INTERFERE WITH THE READ MODELS ? What is the possible workaround?
        transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: @transaction_uid)
        date_of_placement = transaction.created_at
        maturity = transaction.maturity_in_days

        date_of_placement + maturity.day <= max_date_of_settlement 
      end

      def settlement_method_allowed?(settlement_method_id)
        repayment_method = RepaymentType.find_by!(id: @repayment_type_id)
        if repayment_method.name == 'all' || @repayment_type_id == settlement_method_id
          true 
        else  
          false 
        end
      end

      def currency_allowed?(settlement_curency_id)
        settlement_curency_id == @currency_id
      end


      
    end
  end
end