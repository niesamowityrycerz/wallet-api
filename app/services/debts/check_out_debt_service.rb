module Debts 
  class CheckOutDebtService < BaseDebtsService
    def check_out
      Rails.configuration.command_bus.call(
        ::Debts::Commands::CheckOutDebtDetails.new(params)
      )
    end
  end
end