module ReadModels
  module CredibilityPoints
    module Handlers
      class OnCredibilityPointsAlloted
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              credibility_points: event.data.fetch(:credibility_points)
            }
          )

          WriteModels::CredibilityPoints::CredibilityPoint.create!(
            debtor_id: event.data.fetch(:debtor_id),
            points: event.data.fetch(:credibility_points),
            transaction_projection_id: transaction_projection.id
          )

        end
      end 
    end
  end 
end