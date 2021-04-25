module Transactions
  module Handlers
    class OnIssueTransaction 
      include CommandHandler
      
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          if command.data.key?(:group_transaction)
            group = Repositories::Group.new.with_group(command.data.fetch(:group_uid))
            params = command.data.merge(
              max_date_of_settlement: group.transaction_expired_on
            )
          else
            repayment_condition_repository = Repositories::RepaymentCondition.new.with_condition(command.data[:creditor_id])
            params = command.data.merge(
              {
                creditor_conditions: repayment_condition_repository.creditor_conditions
              }
            )
          end 
          transaction.place(params)
        end
      end
    end
  end
end