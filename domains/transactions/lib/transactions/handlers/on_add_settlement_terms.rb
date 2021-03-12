module Transactions
  module Handlers 
    class OnAddSettlementTerms
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          # Do not interfere with the ReadModels 
          transaction.add_settlement_terms(command.data)
        end
      end
    end
  end
end