module Debts 
  module Repositories
    class RepaymentCondition
      RepaymentConditionsDoNotExist = Class.new(StandardError)

      def with_condition(creditor_id)
        repayment_conditions = WriteModels::RepaymentCondition.find_by(creditor_id: creditor_id)
        raise RepaymentConditionsDoNotExist.new 'You have to set repayment conditions first!' unless !repayment_conditions.nil? 

        repayment_condition_entity = Entities::RepaymentCondition.new(          
          {
            creditor_id: repayment_conditions.creditor_id,
            currency_id: repayment_conditions.currency_id,
            maturity_in_days: repayment_conditions.maturity_in_days
          }
        )
      end
    end
  end
end