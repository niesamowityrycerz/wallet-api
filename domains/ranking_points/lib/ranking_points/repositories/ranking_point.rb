module RankingPoints
  module Repositories 
    class RankingPoint 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_ranking_point(transaction_uid, &block)
        stream_name = "RankingPoint$#{transaction_uid}"
        repository.with_aggregate(RankingPointAggregate.new(transaction_uid), stream_name, &block)
      end

      private

      attr_reader :repository

    end
  end
end