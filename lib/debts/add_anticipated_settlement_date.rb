module Debts
  class AddAnticipatedSettlementDate
    def initialize
      @debtors_terms_q = ReadModels::Debts::DebtProjection.accepted
    end

    def call 
      command_pipeline(prepare_commands)
    end

    private 

    def prepare_commands()
      accepted_debts = ReadModels::Debts::DebtProjection.accepted
      created_commands = []
      accepted_debts.each do |debt|
        created_commands << Debts::Commands::AddAnticipatedSettlementDate.new({
          debt_uid: debt.debt_uid,
          anticipated_date_of_settlement: Date.today + rand(1..3)
        })
      end
      created_commands
    end

    def command_pipeline(commands)
      commands.each do |command|
        Rails.configuration.command_bus.call(command)
      end 
    end
  end
end