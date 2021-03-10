module TransactionPoints
  module Repositories 
    class TransactionPoint 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_transaction_point(transaction_uid, &block)
        stream_name = "TransactionPoint$#{transaction_uid}"
        repository.with_aggregate(TransactionPointAggregate.new(transaction_uid), stream_name, &block)
      end

      private

      attr_reader :repository

    end
  end
end