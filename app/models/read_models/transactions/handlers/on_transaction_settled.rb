module ReadModels
  module Transactions
    module Handlers
      class OnTransactionSettled 
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              date_of_settlement: event.data.fetch(:date_of_settlement),
              status: event.data.fetch(:state)
            }
          )
        end
      end
    end
  end
end