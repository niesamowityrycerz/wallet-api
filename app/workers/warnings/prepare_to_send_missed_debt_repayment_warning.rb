module Warnings
  class PrepareToSendMissedDebtRepaymentWarning
    include Sidekiq::Worker

    def perform(debt_uid, debtor_id)
      puts "Warning happend for: #{debt_uid}"
      Rails.configuration.command_bus.call(Warnings::Commands::SendMissedDebtRepaymentWarning.new(
        {
          debt_uid: debt_uid,
          debtor_id: debtor_id
        }
      ))
    end

    def self.cancel_warning(debt_uid)
      Sidekiq::ScheduledSet.new.select do |job|
        job.klass == "Warnings::PrepareToSendMissedDebtRepaymentWarning" && job.args[0] == debt_uid
      end.map(&:delete)
    end

  end
end