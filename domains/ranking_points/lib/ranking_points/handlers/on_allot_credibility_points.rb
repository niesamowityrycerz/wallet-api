module RankingPoints
  module Handlers 
    class OnAllotCredibilityPoints 
      include CommandHandler 

      def call(command)
        debt_uid = command.data[:debt_uid]

        repository = Repositories::RankingPoint.new 
        repository.with_ranking_point(debt_uid) do |ranking_points|
          debt = Repositories::Debt.new.with_debt(debt_uid)

          params = command.data.merge({
            due_money: debt.due_money
          })
          ranking_points.allot_credibility_points(params)
        end
      end
    end
  end
end