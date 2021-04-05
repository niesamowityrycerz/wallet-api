module ReadModels
  module RankingPoints
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
        end
      end 
    end
  end 
end