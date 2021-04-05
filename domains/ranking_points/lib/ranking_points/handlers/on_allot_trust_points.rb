module RankingPoints
  module Handlers 
    class OnAllotTrustPoints 
      include CommandHandler 

      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::RankingPoint.new 
        repository.with_ranking_point(transaction_uid) do |ranking|
          ranking.allot_trust_points(command.data)
        end
      end
    end
  end
end