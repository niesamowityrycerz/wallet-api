module Transactions
  module Handlers 
    class OnAddDebtorTerms
      include CommandHandler
      
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          transaction.add_debtor_terms(command.data)
        end
      end
    end
  end
end