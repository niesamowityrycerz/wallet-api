module Transactions 
  module Handlers 
    include CommandHandler

    class OnInformAdmin 
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Transaction.new 
        repository.with_transaction(transaction_uid) do |transaction|
          transaction.inform_admin(command.data)
        end
      end
    end
  end
end