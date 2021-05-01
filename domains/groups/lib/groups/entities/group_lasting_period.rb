module Groups 
  module Entities
    class GroupLastingPeriod
      def initialize(from, to)
        @from = from 
        @to = to 
      end

      attr_reader :to 

      def repayment_date_valid?(expiration_date)
        expiration_date >= to ? true : false 
      end
    end
  end
end