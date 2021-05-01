module Warnings
  class PrepareToSendMissedDebtRepaymentWarning
    # build sidekiq worker
    include Sidekiq::Worker

    #sidekiq_options queue: 'warnings'

    # every Sidekiq worker has this method
    def perform(debt_uid, debtor_id)
      puts "Warnings happend - #{debt_uid}"
      Rails.configuration.command_bus.call(Warnings::Commands::SendMissedDebtRepaymentWarning.new(
        {
          debt_uid: debt_uid,
          debtor_id: debtor_id
        }
      ))
    end

    # cancel job method
    # it is a class method -> no instance needed to access this method
    def self.cancel_warning(debt_uid)
      Sidekiq::ScheduledSet.new.select do |job|
        job.klass == "Warnings::PrepareToSendMissedDebtRepaymentWarning" && job.args[0] == debt_uid
      end.map(&:delete)
    end

  end
end