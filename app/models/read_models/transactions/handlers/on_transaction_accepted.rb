module ReadModels
  module Transactions 
    module Handlers 
      class OnTransactionAccepted 
        def call(event)
          transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction.update!(
            {
              status: event.data.fetch(:status)
            }
          )
        end
      end
    end
  end
end