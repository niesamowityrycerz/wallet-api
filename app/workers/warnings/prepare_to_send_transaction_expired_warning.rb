module Warnings
  class PrepareToSendTransactionExpiredWarning
    # build sidekiq worker
    include Sidekiq::Worker



    # every Sidekiq worker has this method
    # execure warning job 
    def perform(transaction_uid)
      binding.pry
      puts "Something happend - #{transaction_uid}"
      Rails.configuration.command_bus.call(Warnings::Commands::SendTransactionExpiredWarning.new(
        {
          transaction_uid: transaction_uid   
        }
      ))
    end

    # stop executing warning job  


  end
end