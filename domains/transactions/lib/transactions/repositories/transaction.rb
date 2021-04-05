module Transactions
  module Repositories
    class Transaction
      def initialize(event_store=Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end
      
      def with_transaction(transaction_uid, &block)
        stream_name = "Transaction$#{transaction_uid}"
        # with_agregate method loads an aggregate from a given stream,
        # yield a block to allow performing an action on the aggregate object
        # the aggregate_object will be yielded as a block argument and then publsh all 
        # changes in aggregate to the event store provided to the repository
        repository.with_aggregate(TransactionAggregate.new(transaction_uid), stream_name, &block)
      end

      def with_transaction_data(transaction_uid)
        stream_name = "Transaction$#{transaction_uid}"
        repository.load(TransactionAggregate.new(transaction_uid), stream_name)
      end

      private 
      attr_reader :repository 

    end
  end
end