module CredibilityPoints
  module Calculators 
    class CalculatePenaltyPoints
      def initialize(penalty_counter, amount)
        @penalty_counter = penalty_counter
        @amount = amount
      end

      def call
        penalty_for_day(@penalty_counter) + penalty_for_amount(@amount)
      end

      private 

      def penalty_for_day(counter)
        penalty_for_day_schema = [
          {
            start: 0,
            end: 3,
            value: 1
          },
          {
            start: 4,
            end: 7,
            value: 5
          },
          {
            start: 8,
            end: 15,
            value: 10
          },
          {
            start: 16,
            end: 40,
            value: 20
          }
        ]
          
        penalty_for_day_schema.each do |range|
          if counter > range[:start] && counter < range[:end] 
            @penalty_1 = range[:value]
            break
          end
        end
        return @penalty_1
      end

      def penalty_for_amount(amount)
        penalty_for_amount_schema = [
          {
            start: 1,
            end: 25,
            value: 5
          },
          {
            start: 26,
            end: 50,
            value: 10
          },
          {
            start: 51,
            end: 1000,
            value: 15
          }
        ]
        penalty_for_amount_schema.each do |range|
          if amount > range[:start] && amount < range[:end] 
            @penalty_2 = range[:value]
            break
          end
        end
        return @penalty_2
      end
      
    end
  end
end