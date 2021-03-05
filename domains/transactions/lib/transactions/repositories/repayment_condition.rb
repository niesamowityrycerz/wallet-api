module Transactions 
  module Repositories
    class RepaymentCondition
      def with_condition(creditor_id)
        @repayment_conditions = WriteModels::RepaymentCondition.find_by!(creditor_id: creditor_id)
        # create repayment_conditions_entity 
        repayment_condition_entity = Entities::RepaymentCondition.new(          
          {
            interest: @repayment_conditions.interest,
            creditor_id: @repayment_conditions.creditor_id,
            currency_id: @repayment_conditions.currency_id,
            maturity_in_days: @repayment_conditions.maturity_in_days,
            repayment_type_id: @repayment_conditions.repayment_type_id
          }
        )
      end


    end
  end
end