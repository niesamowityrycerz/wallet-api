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
              settlement_method_id: ( event.data.fetch(:settlement_method_id) if event.data.key?(:settlement_method_id) ),
              group_transaction: ( event.data.fetch(:group_transaction) if event.data.key?(:group_transaction) ),
              group_uid: ( event.data.fetch(:group_uid) if event.data.key?(:group_uid) )
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
          binding.pry
          if event.data.key?(:group_transaction)
            event_store.link(
              event.event_id,
              stream_name: stream_name(event.data.fetch(:group_uid)),
              expected_version: :auto
            )
          end 
        end

        private 

        def event_store 
          binding.pry
          Rails.configuration.event_store 
        end

        def stream_name(group_uid)
          binding
          "Group$#{group_uid}"
        end

      end
    end
  end
end