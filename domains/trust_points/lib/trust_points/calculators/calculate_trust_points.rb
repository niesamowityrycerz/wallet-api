module TrustPoints
  module Calculators 
    class CalculateTrustPoints
      def initialize(debtor_id, due_money)
        @creditor_id = debtor_id
        @due_money = due_money
      end

      def call 
        calculate_points(@debtor_id, @due_money)
      end

      private 

      #TO DO
      def calculate_points(creditor_id, due_money)
        (rand(10.0..100.0) + due_money).round(2)
      end
    end
  end
end