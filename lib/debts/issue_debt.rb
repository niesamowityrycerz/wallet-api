module Debts
  class IssueDebt
    def initialize(creditor_id, debtor_ids, per_user_debt)
      @creditor_id = creditor_id
      @per_user_debt = per_user_debt
      @debtor_ids = debtor_ids
    end


    def call
      commands = prepare_command(@per_user_debt, @creditor_id, @debtor_ids)
      command_pipeline(commands)
    end

    private 

    def prepare_command(tran_quantity, creditor_id, debtor_ids)
      commands = []
      tran_quantity.times do 
        commands << Debts::Commands::IssueDebt.new({
                        debt_uid: SecureRandom.uuid,
                        creditor_id: creditor_id,
                        debtor_id:   debtor_ids.sample,
                        amount:      rand(1.0..100.0).round(2),
                        description: 'test',
                        currency_id: Currency.find_by!(code: 'PLN').id,
                        date_of_transaction: Date.today - rand(1..10) 
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