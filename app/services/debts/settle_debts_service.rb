module Debts 
  class SettleDebtsService 
    def self.settle_debts(debts_uids)
      debts_uids.each do |debt_uid|
        Rails.configuration.command_bus.call(
          Debts::Commands::SettleDebt.send({
            debt_uid: debt_uid
          })
        )
      end 
    end
  end
end