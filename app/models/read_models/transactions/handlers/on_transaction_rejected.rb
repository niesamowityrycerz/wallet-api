module ReadModels
  module Transactions 
    module Handlers
      class OnTransactionRejected 
        def call(event)
          transaction_uid = event.data.fetch(:transaction_uid)

          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)
          transaction_projection.update!({
            status: event.data.fetch(:state),
            reason_for_rejection: event.data.fetch(:reason_for_rejection)
          })
        end
      end
    end
  end
end