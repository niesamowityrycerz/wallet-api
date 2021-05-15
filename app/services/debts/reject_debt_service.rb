module Debts 
  class RejectDebtService < BaseDebtsService
    def reject 
      Rails.configuration.command_bus.call(
        ::Debts::Commands::RejectDebt.send(params)
      )
    end
  end
end