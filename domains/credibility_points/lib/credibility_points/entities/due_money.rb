module CredibilityPoints
  module Entities
    class DueMoney 
      attr_reader :amount
      def initialize(amount)
        @amount = amount
      end
    end
  end
end