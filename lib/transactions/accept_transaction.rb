module Transactions
  class AcceptTransaction 
    def initialize(transaction_uids, quantity=1)
      @transaction_uids = transaction_uids
      @accept_quantity = quantity
    end

    def call
      commands = prepare_command(@transaction_uids, @accept_quantity)
      command_pipeline(commands)
      puts 'Transactions accepted'
    end

    private 

    def prepare_command(transaction_uids, quantity)
      commands = []
      transaction_uids.sample(quantity).each do |tran_uid|
        commands << Transactions::Commands::AcceptTransaction.new({
          transaction_uid: tran_uid
        })
        puts 'Preparing commands...'
      end
      commands 
    end

    def command_pipeline(commands)
      commands.each do |command|
        Rails.configuration.command_bus.call(command)
        puts 'Sending commands...'
      end 
    end

  end
end