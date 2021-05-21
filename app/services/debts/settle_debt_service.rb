module Debts 
  class SettleDebtService < BaseDebtsService
    def settle_debt(debt_uid)
      Rails.configuration.command_bus.call(
        Debts::Commands::SettleDebt.send({
          debt_uid: debt_uid
        })
      )
    end
  end
end