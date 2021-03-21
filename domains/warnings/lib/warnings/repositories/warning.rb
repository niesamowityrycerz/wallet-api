module Warnings
  module Repositories
    class Warning
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_warning(transaction_uid, &block)
        stream_name = "TransactionWarning$#{transaction_uid}"
        repository.with_aggregate(WarningAggregate.new(transaction_uid), stream_name, &block)
      end

      private

      attr_reader :repository
    end
  end
end