module TransactionPoints
  module Handlers 
    class OnAllotCredibilityPoints 
      include CommnadHandler 

      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::TransactionPoint.new 
        repository.with_transaction_point(transaction_uid) do |tran_point|
          tran_point.allot_faith_points(command.data)
        end
      end
    end
  end
end