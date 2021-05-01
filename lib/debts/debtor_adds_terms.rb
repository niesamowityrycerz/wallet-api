module Debts
  class DebtorAddsTerms 
    def initialize(settlement_method_name='one instalment')
      @settlement_method_id = SettlementMethod.find_by!(name: settlement_method_name).id
      @debtors_terms_q = ReadModels::Debts::DebtProjection.accepted

    end

    def call 
      commands = prepare_commands(@settlement_method_id)
      command_pipeline(commands)
    end

    private 

    def prepare_commands(method_id)
      accepted_debts = ReadModels::Debts::DebtProjection.accepted
      created_commands = []
      accepted_debts.each do |tran|
        created_commands << Debts::Commands::AddDebtorTerms.new({
          debt_uid: tran.debt_uid,
          anticipated_date_of_settlement: Date.today + rand(1..3),
          debtor_settlement_method_id: method_id
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