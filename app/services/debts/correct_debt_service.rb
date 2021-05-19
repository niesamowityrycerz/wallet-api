module Debts 
  class CorrectDebtService < BaseDebtsService
    def correct_details 
      Rails.configuration.command_bus.call(
        Debts::Commands::CorrectDebtDetails.send(params)
      )
    end
  end
end