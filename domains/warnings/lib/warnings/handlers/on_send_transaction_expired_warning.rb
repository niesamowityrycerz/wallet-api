module Warnings 
  module Handlers 
    class OnSendTransactionExpiredWarning 
      include CommandHandler

      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Warning.new
        repository.with_warning(transaction_uid) do |warning|
          warning.send_expiration_warning(command.data)
        end
      end
    end
  end
end