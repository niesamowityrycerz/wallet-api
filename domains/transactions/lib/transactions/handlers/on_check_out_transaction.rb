module Transactions
  module Handlers 
    class OnCheckOutTransaction
      include CommandHandler

      def call(command)
        transaction_uid = command.data[:transaction_uid]
        repository = Repositories::Transaction.new 

        repository.with_transaction(transaction_uid) do |transaction|
          transaction.check_out_transaction(command.data)
        end
      end 
    end
  end
end