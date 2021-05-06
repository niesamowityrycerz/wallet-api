module Processes
  class BalanceDebts 
    def initialize(event_store=Rails.configuration.event_store,
                   command_bus=Rails.configuration.command_bus)
      @command_bus = command_bus
      @event_store = event_store
    end 

    attr_reader :command_bus, :event_store

    def call(event)
      if debt_settled?(event)
        @settled_debts << event.data.fetch(:debt_uid)

      end
    end

    private 

    def debt_settled?(event)
      event.data.fetch(:status) == :settled && @debts_uids.include? event.data.fetch(:debt_uid)
    end
  end
end