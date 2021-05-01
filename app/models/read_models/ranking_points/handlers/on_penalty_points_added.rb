module ReadModels
  module RankingPoints
    module Handlers
      class OnPenaltyPointsAdded
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.penalty_points += event.data.fetch(:penalty_points)
          debt_projection.update!(
            {
              status: event.data.fetch(:state)
            }
          )


          debt_warning_projection = ReadModels::Warnings::DebtWarningProjection.find_by!(warning_uid: event.data.fetch(:warning_uid))
          debt_warning_projection.update(
            {
              penalty_points: event.data.fetch(:penalty_points)
            }
          )
        end
      end
    end
  end
end