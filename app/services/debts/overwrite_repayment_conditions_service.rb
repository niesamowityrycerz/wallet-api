module Debts 
  class OverwriteRepaymentConditionsService < BaseDebtsService
    def overwrite_repayment_conditions
      Rails.configuration.command_bus.call(
        Debts::Commands::OverwriteRepaymentConditions.send(params)
      )
    end
  end
end