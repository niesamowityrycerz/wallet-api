module Transactions
  module Handlers
    class OnIssueTransaction 
      # access to methods defined in ComandHandler module 
      include CommandHandler
      # code to submit transaction
      def call(command)
        transaction_uid = SecureRandom.uuid

        repository = Repositories::Transaction.new
        repository.with_transaction(transaction_uid) do |transaction|
          command.data.merge!({transaction_uid: transaction_uid})
          transaction.place(command.data)
          binding.pry
        end
      end

    end
  end
end