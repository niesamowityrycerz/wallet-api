module TransactionPoints
  module Handlers
    class OnCalculateFaithPoints 
      include CommandHandler
      
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::TransactionPoint.new
        repository.with_transaction_point(transaction_uid) do |tran_point|
          tran_point.calculate_faith_points(command.data)
        end
      end
    end
  end
end