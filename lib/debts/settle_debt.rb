module Debts
  class SettleDebt 
    def initialize(debt_uids, on_time)
      @on_time = debt_uids.sample(on_time)
      @not_on_time = debt_uids - @on_time
    end

    def call
      settle_debts(@on_time)
      settle_debts(@not_on_time, Date.today + rand(10..30))
    end

    private 

    def settle_debts(debt_uids, date = Date.today)
      commands = []
      debt_uids.each do |tran_uid|
        commands << Debts::Commands::SettleDebt.new({
          debt_uid: tran_uid,
          date_of_settlement: date + rand(3..8)
        })
      end
      command_pipeline(commands)
    end

    def command_pipeline(commands)
      commands.each do |command|
        Rails.configuration.command_bus.call(command)
      end 
    end

  end
end