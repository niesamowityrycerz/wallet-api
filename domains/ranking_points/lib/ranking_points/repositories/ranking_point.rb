module RankingPoints
  module Repositories 
    class RankingPoint 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_ranking_point(debt_uid, &block)
        stream_name = "RankingPoint$#{debt_uid}"
        repository.with_aggregate(RankingPointAggregate.new(debt_uid), stream_name, &block)
      end

      private

      attr_reader :repository

    end
  end
end