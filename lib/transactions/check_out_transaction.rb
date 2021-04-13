module Transactions
  class CheckOutTransaction
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
        commands << Transactions::Commands::CheckOutTransaction.new({
          transaction_uid: tran_uid,
          doubts: Faker::Quote.famous_last_words[0..40]
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