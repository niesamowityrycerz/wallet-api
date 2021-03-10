module Transactions
  module Handlers 
    class OnAddSettlementTerms
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          # Do not interfere with the ReadModels 
          repayment_condition_repository = Repositories::RepaymentCondition.new.with_condition(command.data[:creditor_id])
          params = command.data.merge(
            {
              repayment_conditions: repayment_condition_repository.creditor_conditions
            }
          )
          transaction.repayment_conditions = repayment_condition_repository

          transaction.add_settlement_terms(params)
        end
      end
    end
  end
end