module ReadModels
  module Transactions 
    module Handlers
      class OnTransactionIssued 
        # this creates new object
        # of the TransactionProjection read model
        # by default rails_event_store require handlers to respond to #call method
        def call(event)
          # create new record in transaction_projections tables
          ReadModels::Transactions::TransactionProjection.create!(
            {
              creditor_id: event.data.fetch(:creditor_id),
              debtor_id: event.data.fetch(:debtor_id),
              transaction_uid: event.data.fetch(:transaction_uid),
              amount: event.data.fetch(:amount),
              currency_id: event.data.fetch(:currency_id),
              description: event.data.fetch(:description),
              maturity_in_days: event.data.fetch(:maturity_in_days),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) )
            }.compact
          )


          # link published event to additional stream 
          # nie działa 
          event_store.link(
            event.event_id,
            stream_name: stream_name(event.data[:creditor_id]),
            expected_version: :any
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