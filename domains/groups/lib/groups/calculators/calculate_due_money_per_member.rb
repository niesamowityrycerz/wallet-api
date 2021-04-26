module Groups
  module Calculators 
    class CalculateDueMoneyPerMember

      def self.call(recievers, total_amount)
        (total_amount/recievers.count).round(2)
      end

    end
  end
end
