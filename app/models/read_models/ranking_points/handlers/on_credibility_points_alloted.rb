module ReadModels
  module RankingPoints
    module Handlers
      class OnCredibilityPointsAlloted
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update(
            {
              credibility_points: event.data.fetch(:credibility_points),
              adjusted_credibility_points: event.data.fetch(:adjusted_credibility_points) 
            }
          )

          ranking_position =  ReadModels::Rankings::DebtorRankingProjection.find_by!(debtor_id: event.data.fetch(:debtor_id))
          ranking_position.update!({
            adjusted_credibility_points: ranking_position.adjusted_credibility_points + event.data.fetch(:adjusted_credibility_points),
            debts_quantity: ranking_position.debts_quantity + 1
          })
        end
      end 
    end
  end 
end