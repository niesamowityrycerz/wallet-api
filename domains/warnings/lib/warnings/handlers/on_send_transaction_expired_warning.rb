module Warnings 
  module Handlers 
    class OnSendTransactionExpiredWarning 
      include CommandHandler

      def call(command)
        transaction_uid = command.data[:transaction_uid]

        repository = Repositories::Warning.new
        repository.with_warning(transaction_uid) do |warning|
          params = command.data.merge({
            warning_type_id: WarningType.find_by!(name: 'transaction expired').id,
            warning_uid: SecureRandom.uuid 
          })
          warning.send_expiration_warning(params)
        end
      end
    end
  end
end