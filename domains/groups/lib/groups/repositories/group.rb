module Groups 
  module Repositories
    class Group 
      def initialize(event_store=Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_group(group_uid, &block)
        stream_name = "Group$#{group_uid}"
        repository.with_aggregate(GroupAggregate.new(group_uid), stream_name, &block)
      end

      def with_group_data(group_uid)
        stream_name = "Group$#{group_uid}"
        repository.load(GroupAggregate.new(group_uid), stream_name)
      end

      private

      attr_reader :repository
    end
  end
end