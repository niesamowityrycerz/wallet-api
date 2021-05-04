module Debts
  module Handlers
    class OnIssueDebt
      include CommandHandler
      
      def call(command)
        debt_uid = command.data[:debt_uid]

        repository = Repositories::Debt.new
        repository.with_debt(debt_uid) do |debt|
          if !command.data.key?(:group_uid)
            repayment_condition_repository = Repositories::RepaymentCondition.new.with_condition(command.data[:creditor_id])
            command.data.merge!({
                creditor_conditions: repayment_condition_repository.creditor_conditions
            })
          end 
          debt.place(command.data)
        end
      end
    end
  end
end