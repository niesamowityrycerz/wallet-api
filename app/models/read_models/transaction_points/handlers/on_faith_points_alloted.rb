module ReadModels
  module TransactionPoints
    module Handlers
      class OnFaithPointsAlloted
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              faith_points: event.data.fetch(:faith_points)
            }
          )

          WriteModels::TransactionPoints::FaithPoint.create!(
            creditor_id: event.data.fetch(:creditor_id),
            points: event.data.fetch(:faith_points),
            transaction_projection_id: transaction_projection.id
          )
        end
      end
    end
  end
end