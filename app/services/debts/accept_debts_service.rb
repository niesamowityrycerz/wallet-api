module Debts 
  class AcceptDebtsService < BaseDebtsService 
    def accept
      Rails.configuration.command_bus.call(
        ::Debts::Commands::AcceptDebt.new(params)
      )
    end
  end
end