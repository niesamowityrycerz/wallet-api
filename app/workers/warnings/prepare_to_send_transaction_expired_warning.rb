module Warnings
  class PrepareToSendTransactionExpiredWarning
    # build sidekiq worker
    include Sidekiq::Worker

    #sidekiq_options queue: 'warnings'

    # every Sidekiq worker has this method
    def perform(transaction_uid, debtor_id)
      puts "Warnings happend - #{transaction_uid}"
      Rails.configuration.command_bus.call(Warnings::Commands::SendTransactionExpiredWarning.new(
        {
          transaction_uid: transaction_uid,
          debtor_id: debtor_id
        }
      ))
    end

    # cancel job method
    # it is a class method -> no instance needed to access this method
    def self.cancel_warning(transaction_uid)
      Sidekiq::ScheduledSet.new.select do |job|
        job.klass == "Warnings::PrepareToSendTransactionExpiredWarning" && job.args[0] == transaction_uid
      end.map(&:delete)
    end

  end
end