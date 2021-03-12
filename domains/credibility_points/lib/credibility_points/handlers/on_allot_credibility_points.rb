module CredibilityPoints
  module Handlers 
    class OnAllotCredibilityPoints 
      include CommandHandler 

      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::CredibilityPoint.new 
        repository.with_credibility_point(transaction_uid) do |tran_point|
          tran_point.allot_credibility_points(command.data)
        end
      end
    end
  end
end