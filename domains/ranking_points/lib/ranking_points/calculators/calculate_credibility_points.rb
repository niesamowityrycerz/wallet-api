module RankingPoints
  module Calculators
    class CalculateCredibilityPoints
      def initialize(debtor_id, due_money, expire_on)
        @debtor = User.find_by!(id: debtor_id)
        @due_money = due_money
        @expire_on = expire_on
      end

      def call 
        credibility_points(@debtor, @due_money, @expire_on)
      end

      private 

      def credibility_points(user, due_money, expire_on)
        multiplier = 0.1 #TODO 
        points = before_expiration(expire_on) *  multiplier + due_money
        points.round(2)
      end

      def before_expiration(expire_on)
        if (@expire_on - Date.today).to_i > 0 
          (@expire_on - Date.today).to_i
        else 
          1
        end
      end
    end
  end
end