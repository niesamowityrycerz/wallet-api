module CredibilityPoints 
  module Handlers 
    class OnAddPenaltyPoints
      NoWarningsForTransaction = Class.new(StandardError)
      def call(command)
        transaction_uid = command.data[:transaction_uid]
        warnings_counter = WriteModels::Warning.where(transaction_uid: transaction_uid).count
        raise NoWarningsForTransaction.new unless !warnings_counter.nil?

        due_money = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid).amount 
        repository = Repositories::CredibilityPoint.new 
        repository.with_credibility_point(transaction_uid) do |penalty_points|
          penalty_points.due_money = Entities::DueMoney.new(due_money)

          params = command.data.merge({
            warnings_counter: warnings_counter
          })
          penalty_points.add_penalty_points(params)
        end
      end
    end
  end
end