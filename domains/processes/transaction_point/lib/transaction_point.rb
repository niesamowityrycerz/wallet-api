module Processes
  class TransactionPoint
    def initialize(event_store=Rails.configuration.event_store,
                    command_bus=Rails.configuration.command_bus)
      @command_bus = command_bus
      @event_store = event_store
    end 

    # TO JEST SYSTEM
    # deleguje commendy na podstawie przeszlych zdarzeń 

    def call(event)
      if transaction_settled?(event)
        binding.pry
        command_bus.call(
          TransactionPoints::Commands::CalculateCredibilityPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid),
              debtor_id: event.data.fetch(:debtor_id),
              due_money: event.data.fetch(:amount)
            }
          )
        )
        command_bus.call(
          TransactionPoints::Commands::CalculateFaithPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid),
              creditor_id: event.data.fetch(:creditor_id),
              due_money: event.data.fetch(:amount)
            }
          )
        )
      elsif credibility_points_calculated?(event)
        command_bus.call(
          TransactionPoints::Commands::AllotCredibilityPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid)
            }
          )
        )
      elsif faith_points_calculated?(event)
        command_bus.call(
          TransactionPoints::Commands::AllotFaithPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid)
            }
          )
        )
      end


    end

    private 

    def transaction_settled?(event)
      event.data.fetch(:status) == :settled
    end

    def credibility_points_calculated?(event)
      event.data.fetch(:status) == :credibility_points_calculated
    end

    def faith_points_calculated?(event)
      event.data.fetch(:status) == :credibility_points_calculated
    end

    # create new stream with flags as data




    
  end
end