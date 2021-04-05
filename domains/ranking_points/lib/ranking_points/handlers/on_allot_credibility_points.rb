module RankingPoints
  module Handlers 
    class OnAllotCredibilityPoints 
      include CommandHandler 

      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::RankingPoint.new 
        repository.with_ranking_point(transaction_uid) do |ranking_points|
          transaction = Repositories::Transaction.new.with_transaction(transaction_uid)

          params = command.data.merge({
            due_money: transaction.due_money
          })
          ranking_points.allot_credibility_points(params)
        end
      end
    end
  end
end