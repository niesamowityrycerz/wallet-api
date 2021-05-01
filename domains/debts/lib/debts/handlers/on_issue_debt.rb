module Debts
  module Handlers
    class OnIssueDebt
      include CommandHandler
      
      def call(command)
        debt_uid = command.data[:debt_uid]

        repository = Repositories::Debt.new
        repository.with_debt(debt_uid) do |debt|
          if command.data.key?(:group_debt)
            group = Repositories::Group.new.with_group(command.data.fetch(:group_uid))
            params = command.data.merge(
              max_date_of_settlement: group.debt_expired_on
            )
          else
            repayment_condition_repository = Repositories::RepaymentCondition.new.with_condition(command.data[:creditor_id])
            params = command.data.merge(
              {
                creditor_conditions: repayment_condition_repository.creditor_conditions
              }
            )
          end 
          debt.place(params)
        end
      end
    end
  end
end