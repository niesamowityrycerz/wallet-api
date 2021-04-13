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

          ranking_position = WriteModels::CreditorsRanking.find_by!(creditor_id: event.data.fetch(:creditor_id))
          ranking_position.credit_transactions += 1
          ranking_position.trust_points += event.data.fetch(:trust_points)
          ranking_position.save!
        end
      end
    end
  end 
end