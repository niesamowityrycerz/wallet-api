module ReadModels
  module RankingPoints
    module Handlers
      class OnTrustPointsAlloted
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              trust_points: event.data.fetch(:trust_points),
              status: event.data.fetch(:state)
            }
          )
        end
      end
    end
  end 
end