module RankingPoints
  module Calculators
    class CalculateCredibilityPoints
      def initialize(debtor_id, due_money, expire_on)
        @debtor = User.find_by!(id: debtor_id)
        @due_money = due_money
        @expire_on = expire_on
      end

      def call 
        credibility_points(@debtor, @expire_on)
      end

      private

      def credibility_points(debtor, expire_on)
        multiplier = 0.1 #TODO 
        points = before_expiration(expire_on) *  multiplier + @due_money + warning_premium(debtor)
        points.round(2)
      end

      def before_expiration(expire_on)
        if (expire_on - Date.today).to_i > 0 
          (expire_on - Date.today).to_i
        else 
          1
        end
      end

      def warning_premium(debtor)
        warnings = WriteModels::Warning.where(user_id: debtor.id).count 
        premium_points_schema.each do |step|
          if warnings <= step[:to] && warnings >= step[:from]
            @premium = step[:premium]
            break
          end
        end
        @premium  
      end

      def premium_points_schema
        [
          {
            from: 0,
            to: 3,
            premium: 10
          },
          {
            from: 4,
            to: 7,
            premium: 5
          },
          from: 8,
          to: 1000,
          premium: 0
        ]
      end
    end
  end
end