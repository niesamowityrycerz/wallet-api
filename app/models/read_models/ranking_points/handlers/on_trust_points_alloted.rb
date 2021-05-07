module ReadModels
  module RankingPoints
    module Handlers
      class OnTrustPointsAlloted
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update!(
            {
              trust_points: event.data.fetch(:trust_points),
              status: event.data.fetch(:state)
            }
          )

          ranking_position = WriteModels::CreditorsRanking.find_by!(creditor_id: event.data.fetch(:creditor_id))
          ranking_position.update!({
            credits_quantity: ranking_position.credits_quantity + 1,
            trust_points: ranking_position.trust_points + event.data.fetch(:trust_points)
          })
     
        end
      end
    end
  end 
end