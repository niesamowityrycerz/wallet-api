module TrustPoints
  module Handlers
    class OnCalculateTrustPoints 
      include CommandHandler
      
      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::TrustPoint.new
        repository.with_trust_point(transaction_uid) do |ranking|
          ranking.calculate_trust_points(command.data)
        end
      end
    end
  end
end