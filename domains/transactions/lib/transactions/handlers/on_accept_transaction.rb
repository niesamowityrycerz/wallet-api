module Transactions 
  module Handlers
    class OnAcceptTransaction 
      include CommandHandler

      def call(command)
        transaction_uid = command.data[:transaction_uid]
        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          transaction.accept_transaction
        end
      end

    end
  end
end