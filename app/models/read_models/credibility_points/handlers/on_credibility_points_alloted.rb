module ReadModels
  module CredibilityPoints
    module Handlers
      class OnCredibilityPointsAlloted
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update(
            {
              credibility_points: event.data.fetch(:credibility_points),
              adjusted_credibility_points: event.data.fetch(:adjusted_credibility_points) 
            }
          )

          WriteModels::CredibilityPoint.create!(
            debtor_id: event.data.fetch(:debtor_id),
            points: event.data.fetch(:credibility_points),
            transaction_projection: transaction_projection
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