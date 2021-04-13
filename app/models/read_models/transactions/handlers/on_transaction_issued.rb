module ReadModels
  module Transactions 
    module Handlers
      class OnTransactionIssued 
        def call(event)
          transaction_uid = event.data.fetch(:transaction_uid)
          ReadModels::Transactions::TransactionProjection.create!(
            {
              creditor_id: event.data.fetch(:creditor_id),
              debtor_id: event.data.fetch(:debtor_id),
              transaction_uid: transaction_uid,
              amount: event.data.fetch(:amount),
              currency_id: event.data.fetch(:currency_id),
              description: event.data.fetch(:description),
              max_date_of_settlement: event.data.fetch(:max_date_of_settlement),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
              status: event.data.fetch(:state),
              settlement_method_id: event.data.fetch(:settlement_method_id)
            }.compact
          )

          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)
          WriteModels::FinancialTransaction.create!(
            {
              debtor_id:   event.data.fetch(:debtor_id),
              creditor_id: event.data.fetch(:creditor_id),
              amount:      event.data.fetch(:amount),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
              transaction_projection_id: transaction_projection.id
            }
          )


          # link published event to additional stream 
          # nie działa 
          event_store.link(
            event.event_id,
            stream_name: stream_name(event.data[:creditor_id]),
            expected_version: :auto
          )
        end

        private 

        def event_store 
          Rails.configuration.event_store 
        end

        def stream_name(creditor_id)
          "TransactionPlacedByUser_#{creditor_id}"
        end

      end
    end
  end
end