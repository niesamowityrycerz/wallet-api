module RankingPoints
  module Handlers 
    class OnAddPenaltyPoints
      NoWarningsForTransaction = Class.new(StandardError)
      def call(command)
        transaction_uid = command.data[:transaction_uid]
        warnings_counter = WriteModels::Warning.where(transaction_uid: transaction_uid).count
        raise NoWarningsForTransaction.new unless !warnings_counter.nil?

        repository = Repositories::RankingPoint.new 
        repository.with_ranking_point(transaction_uid) do |ranking_points|
          transaction = Repositories::Transaction.new.with_transaction(transaction_uid)

          params = command.data.merge({
            due_money: transaction.due_money,
            warnings_counter: warnings_counter
          })
          ranking_points.add_penalty_points(params)
        end
      end
    end
  end
end