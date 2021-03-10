module ReadModels
  module Transactions 
    module Handlers 
      class OnTransactionAcceptedRejectedPendingOrClosed
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              status: event.data.fetch(:status),
              reason_for_closing: ( event.data.fetch(:reason_for_closing) if event.data.key?(:reason_for_closing) )
            }.compact
          )
        end
      end
    end
  end
end