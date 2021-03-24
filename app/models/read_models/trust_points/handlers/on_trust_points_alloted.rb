module ReadModels
  module TrustPoints
    module Handlers
      class OnTrustPointsAlloted
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              trust_points: event.data.fetch(:trust_points),
              status: event.data.fetch(:status)
            }
          )

          WriteModels::TrustPoint.create!(
            creditor_id: event.data.fetch(:creditor_id),
            points: event.data.fetch(:trust_points),
            transaction_projection_id: transaction_projection.id
          )

          # link event to another stream 
          event_store.link(
          event.event_id,
          stream_name: stream_name(event.data.fetch(:transaction_uid)),
          expected_version: :any
        )
        end

        private 

        def event_store 
          Rails.configuration.event_store
        end

        def stream_name(transaction_uid)
          "TransactionPoint$#{transaction_uid}"
        end
      end
    end
  end 
end