module ReadModels
  module Transactions
    module Handlers
      class OnTransactionCorrected
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              amount: ( event.data.fetch(:amount) if event.data.key?(:amount) ),
              currency_id: ( event.data.fetch(:currency_id) if event.data.key?(:currency_id) ),
              description: ( event.data.fetch(:description) if event.data.key?(:description) ),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
              status: event.data.fetch(:state)
            }
          )
        end
      end
    end
  end
end