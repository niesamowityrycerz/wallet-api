module Transactions
  module Handlers
    class OnIssueTransaction 
      # access to methods defined in ComandHandler module 
      include CommandHandler
      # code to submit transaction
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          repayment_condition_repository = Repositories::RepaymentCondition.new.with_condition(command.data[:creditor_id])
          params = command.data.merge(
            {
              transaction_uid: transaction_uid,
              creditor_conditions: repayment_condition_repository.creditor_conditions
            }
          )

          transaction.place(params)
        end
      end

    end
  end
end