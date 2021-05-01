module RankingPoints
  module Handlers 
    class OnAddPenaltyPoints
      NoWarningsForDebt = Class.new(StandardError)
      def call(command)
        debt_uid = command.data[:debt_uid]
        warnings_counter = WriteModels::Warning.where(debt_uid: debt_uid).count
        raise NoWarningsForDebt.new unless !warnings_counter.nil?

        repository = Repositories::RankingPoint.new 
        repository.with_ranking_point(debt_uid) do |ranking_points|
          debt = Repositories::Debt.new.with_debt(debt_uid)

          params = command.data.merge({
            due_money: debt.due_money,
            warnings_counter: warnings_counter
          })
          ranking_points.add_penalty_points(params)
        end
      end
    end
  end
end