module Debts
  class CorrectDebtDetails
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
      debt_uids.each do |tran_uid|
        commands << Debts::Commands::CorrectDebtDetails.new(
          build_command_hash.merge({ debt_uid: tran_uid }))
      end
      commands 
    end

    def build_command_hash 
      base_command = {}
      attribute_to_correct.each do |key|
        base_command[key] = attributes[key]
      end
      base_command
    end

    def attribute_to_correct
      keys = attributes.keys
      to_sample = rand(1..4)
      keys.sample(to_sample)
    end

    def attributes
      @attrs = {
        currency_id: Currency.ids.sample,
        amount: rand(10.0..1000.0),
        description: Faker::Quote.famous_last_words,
        date_of_transaction: Date.today - rand(1..100)
      }
    end

    def command_pipeline(commands)
      commands.each do |command|
        Rails.configuration.command_bus.call(command)
      end 
    end
  end
end