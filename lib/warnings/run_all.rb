module Warnings 
  class RunAll 
    def initialize(warnings_quantity = 10)
      @warnings_q = warnings_quantity
    end

    def call
      parameters = sample_transactions(@warnings_q)
      command_pipeline(parameters)
    end

    private 

    def sample_transactions(to_sample)
      transactions = command_data.keys.sample(to_sample)
      parameters_to_send = command_data.slice(*transactions)
    end

    def command_data
      data = {}
      ReadModels::Transactions::TransactionProjection.all.each do |transaction|
        data[transaction.transaction_uid] = transaction.debtor_id
      end 
      data 
    end

    def command_pipeline(parameters)
      parameters.each do |transaction_uid, debtor_id|
        Rails.configuration.command_bus.call(
          Warnings::Commands::SendTransactionExpiredWarning.new({
            transaction_uid: transaction_uid,
            debtor_id: debtor_id
          })
        )
      end 
    end

  end
end