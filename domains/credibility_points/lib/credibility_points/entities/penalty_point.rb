module CredibilityPoints
  module Entities
    class PenaltyPoint 
      attr_reader :points
      def initialize(points)
        @points = points 
      end
    end
  end
end