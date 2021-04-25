module Transactions
  module Repositories
    class Group 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_group(group_uid)
        Groups::Repositories::Group.new.with_group_data(group_uid)
      end
    end
  end
end