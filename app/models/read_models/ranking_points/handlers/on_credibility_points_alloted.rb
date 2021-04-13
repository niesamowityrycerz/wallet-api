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


          ranking_position =  WriteModels::DebtorsRanking.find_by!(debtor_id: event.data.fetch(:debtor_id))
          ranking_position.debt_transactions += 1
          ranking_position.adjusted_credibility_points += event.data.fetch(:adjusted_credibility_points)
          ranking_position.save!
        end
      end 
    end
  end 
end