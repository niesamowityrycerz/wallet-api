module TrustPoints
  module Repositories 
    class TrustPoint 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_trust_point(transaction_uid, &block)
        stream_name = "TrustPoint$#{transaction_uid}"
        repository.with_aggregate(TrustPointAggregate.new(transaction_uid), stream_name, &block)
      end

      private

      attr_reader :repository

    end
  end
end