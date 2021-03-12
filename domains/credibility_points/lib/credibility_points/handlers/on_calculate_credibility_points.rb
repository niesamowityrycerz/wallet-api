module CredibilityPoints 
  module Handlers 
    class OnCalculateCredibilityPoints 
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::CredibilityPoint.new 
        repository.with_credibility_point(transaction_uid) do |ranking|
          ranking.calculate_credibility_points(command.data)
        end
      end
    end
  end
end