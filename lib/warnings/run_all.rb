module Warnings 
  class RunAll 
    def initialize(warnings_quantity = 10)
      @warnings_q = warnings_quantity
    end

    def call
      parameters = sample_debts(@warnings_q)
      command_pipeline(parameters)
    end

    private 

    def sample_debts(to_sample)
      debts = command_data.keys.sample(to_sample)
      parameters_to_send = command_data.slice(*debts)
    end

    def command_data
      data = {}
      ReadModels::Debts::DebtProjection.all.each do |debt|
        data[debt.debt_uid] = debt.debtor_id
      end 
      data 
    end

    def command_pipeline(parameters)
      parameters.each do |debt_uid, debtor_id|
        Rails.configuration.command_bus.call(
          Warnings::Commands::SendMissedDebtRepaymentWarning.new({
            debt_uid: debt_uid,
            debtor_id: debtor_id
          })
        )
      end 
    end

  end
end