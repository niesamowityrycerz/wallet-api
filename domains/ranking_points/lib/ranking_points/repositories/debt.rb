module RankingPoints
  module Repositories
    class Debt 
      def initialize(event_store = Rails.configuration.event_store)
        @repository = AggregateRoot::Repository.new(event_store)
      end

      def with_debt(debt_uid)
        Debts::Repositories::Debt.new.with_debt_data(debt_uid)
      end
    end
  end 
end