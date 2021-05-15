module Debts 
  class CloseDebtsService < BaseDebtsService
    def close 
      Rails.configuration.command_bus.call(
        ::Debts::Commands::CloseDebt.new(params)
      )
    end
  end
end