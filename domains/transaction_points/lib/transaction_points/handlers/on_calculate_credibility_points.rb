module TransactionPoints 
  module Handlers 
    class OnCalculateCredibilityPoints 
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::TransactionPoint.new 
        repository.with_transaction_point(transaction_uid) do |tran_point|
          tran_point.calculate_credibility_points(command.data)
        end
      end
    end
  end
end