module Debts
  class RejectDebt 
    def initialize(debt_uids)
      @debt_uids = debt_uids
    end

    def call
      commands = prepare_command(@debt_uids)
      command_pipeline(commands)
    end

    private 

    def prepare_command(debt_uids)
      commands = []
      debt_uids.each do |debt_uid|
        commands << Debts::Commands::AcceptDebt.new({
          debt_uid: debt_uid
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