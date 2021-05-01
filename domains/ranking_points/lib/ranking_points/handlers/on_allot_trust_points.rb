module RankingPoints
  module Handlers 
    class OnAllotTrustPoints 
      include CommandHandler 

      def call(command)
        debt_uid = command.data[:debt_uid]

        repository = Repositories::RankingPoint.new 
        repository.with_ranking_point(debt_uid) do |ranking|
          ranking.allot_trust_points(command.data)
        end
      end
    end
  end
end