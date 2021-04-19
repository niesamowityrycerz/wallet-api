module Transactions
  class SettleTransaction 
    def initialize(transaction_uids, on_time)
      @on_time = transaction_uids.sample(on_time)
      @not_on_time = transaction_uids - @on_time
    end

    def call
      settle_transactions(@on_time)
      settle_transactions(@not_on_time, Date.today + rand(10..30))
    end

    private 

    def settle_transactions(transaction_uids, date = Date.today)
      commands = []
      transaction_uids.each do |tran_uid|
        commands << Transactions::Commands::SettleTransaction.new({
          transaction_uid: tran_uid,
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