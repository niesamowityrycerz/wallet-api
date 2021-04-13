module Transactions
  class RejectTransaction 
    def initialize(transaction_uids)
      @transaction_uids = transaction_uids
    end

    def call
      commands = prepare_command(@transaction_uids)
      command_pipeline(commands)
    end

    private 

    def prepare_command(transaction_uids)
      commands = []
      transaction_uids.each do |tran_uid|
        commands << Transactions::Commands::AcceptTransaction.new({
          transaction_uid: tran_uid
        })
      end
      commands 
    end

    def command_pipeline(commands)
      commands.each do |command|
        Rails.configuration.command_bus.call(command)
      end 
    end

  end
end