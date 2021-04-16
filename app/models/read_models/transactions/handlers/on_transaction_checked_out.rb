module ReadModels
  module Transactions
    module Handlers
      class OnTransactionCheckedOut 
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              doubts: event.data.fetch(:doubts),
              status: event.data.fetch(:state)
            }
          )
        end
      end
    end
  end
end