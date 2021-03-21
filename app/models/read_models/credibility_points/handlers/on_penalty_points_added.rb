module ReadModels
  module CredibilityPoints
    module Handlers
      class OnPenaltyPointsAdded
        def call(event)
          #transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          #transaction_projection.penalty_points += event.data.fetch(:penalty_points)

          transaction_warning_projection = ReadModels::Warnings::TransactionWarningProjection.find_by!(warning_uid: event.data.fetch(:warning_uid))
          transaction_warning_projection.update(
            {
              penalty_points: event.data.fetch(:penalty_points)
            }
          )

          transaction_warning = WriteModels::Warnings::TransactionWarning.find_by!(warning_uid: event.data.fetch(:warning_uid))
          transaction_warning.update(
            {
              penalty_points: event.data.fetch(:penalty_points)
            }
          )

        end
      end
    end
  end
end