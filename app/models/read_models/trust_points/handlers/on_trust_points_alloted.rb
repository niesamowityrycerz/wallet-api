module ReadModels
  module TrustPoints
    module Handlers
      class OnTrustPointsAlloted
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              trust_points: event.data.fetch(:trust_points)
            }
          )

          WriteModels::TrustPoints::TrustPoint.create!(
            creditor_id: event.data.fetch(:creditor_id),
            points: event.data.fetch(:trust_points),
            transaction_projection_id: transaction_projection.id
          )
        end
      end
    end
  end 
end