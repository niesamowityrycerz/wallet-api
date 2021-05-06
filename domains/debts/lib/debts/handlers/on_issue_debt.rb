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
          # ! COMPARE !
          # binding.pry 
          # if command.data.key?(:group_uid)
          #   group = Debts::Repositories::Group.new.with_group(command.data[:group_uid])
          #   #binding.pry
          #   command.data.merge!({
          #     max_date_of_settlement: group.debt_repayment_valid_till
          #   })
          # else 
          #   #binding.pry
          #   repayment_condition_repository = Repositories::RepaymentCondition.new.with_condition(command.data[:creditor_id])
          #   command.data.merge!({
          #     creditor_conditions: repayment_condition_repository.creditor_conditions
          #   })
          # end
          debt.issue(command.data)
        end
      end
    end
  end
end