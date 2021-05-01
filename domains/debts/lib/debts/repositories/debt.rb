module Debts
  module Repositories
    class Debt
      def initialize(event_store=Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end
      
      def with_debt(debt_uid, &block)
        stream_name = "Debt$#{debt_uid}"
        # with_agregate method loads an aggregate from a given stream,
        # yield a block to allow performing an action on the aggregate object
        # the aggregate_object will be yielded as a block argument and then publsh all 
        # changes in aggregate to the event store provided to the repository
        repository.with_aggregate(DebtAggregate.new(debt_uid), stream_name, &block)
      end

      def with_debt_data(debt_uid)
        stream_name = "Debt$#{debt_uid}"
        repository.load(DebtAggregate.new(debt_uid), stream_name)
      end

      private 
      attr_reader :repository 

    end
  end
end