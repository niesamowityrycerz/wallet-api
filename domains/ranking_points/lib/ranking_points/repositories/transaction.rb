module RankingPoints
  module Repositories
    class Transaction 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_transaction(transaction_uid)
        Transactions::Repositories::Transaction.new.with_transaction_data(transaction_uid)
      end
    end
  end 
end