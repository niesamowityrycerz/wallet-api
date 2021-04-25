module Transactions
  module Calculators 
    class CalculateDueMoneyPerMember

      def self.call(debtors, total_amount)
        (total_amount/debtors.count).round(2)
      end

    end
  end
end
