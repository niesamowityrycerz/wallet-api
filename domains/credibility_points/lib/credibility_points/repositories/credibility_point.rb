module CredibilityPoints
  module Repositories 
    class CredibilityPoint 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_credibility_point(transaction_uid, &block)
        stream_name = "CredibilityPoint$#{transaction_uid}"
        repository.with_aggregate(CredibilityPointAggregate.new(transaction_uid), stream_name, &block)
      end

      private

      attr_reader :repository

    end
  end
end