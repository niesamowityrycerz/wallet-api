module ReadModels
  module Transactions 
    module Handlers
      class OnAdminInformed
        def call(event)
          transaction_uid = event.data.fetch(:transaction_uid)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: transaction_uid)

          transaction_projection.update(
            {
              admin_informed: true,
              message_to_admin: event.data.fetch(:message_to_admin),
              status: event.data.fetch(:status)
            }
          )

        end
      end
    end
  end
end