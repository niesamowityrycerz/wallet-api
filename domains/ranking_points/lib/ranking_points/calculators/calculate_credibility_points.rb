module RankingPoints
  module Calculators
    class CalculateCredibilityPoints
      # settlement_date
      # max_date_of_settlement
      # jak mieć dostęp do tych parametrów?
      def initialize(debtor_id, due_money)
        # more warnings -> less credibility points; TODO 
        @debtor = User.find_by!(id: debtor_id)
        @due_money = due_money
      end

      def call 
        credibility_points(@debtor, @due_money)
      end

      private 

      def credibility_points(user, due_money)
        multiplier = 0.1   
        points = ((Time.now - user.created_at) / 3600 ) *  multiplier + due_money
        points.round(2)
      end
    end
  end
end