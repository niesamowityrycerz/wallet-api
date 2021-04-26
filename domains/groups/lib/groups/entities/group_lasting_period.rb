module Groups 
  module Entities
    class GroupLastingPeriod
      def initialize(from, to)
        @from = from 
        @to = to 
      end

      attr_reader :to 

      def transaction_expired_on_valid?(expiration_date)
        expiration_date >= to ? true : false 
      end
    end
  end
end