module ReadModels
  module Warnings
    module Handlers
      class OnTransactionExpiredWarningSent
        def call(event)
          transaction_uid = event.data.fetch(:transaction_uid)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              status: event.data.fetch(:state)
            }
          )
          

          # create transaction warning projection(ReadModels)
          warning_type = WarningType.find_by!(id: event.data.fetch(:warning_type_id))
          # create -> new record(dynamic)
          # find_or_create_by -> change the exisiting record(static)
          ReadModels::Warnings::TransactionWarningProjection.create!(
            {
              user_id: event.data.fetch(:user_id),
              warning_type_name: warning_type.name,
              transaction_uid: transaction_uid,
              warning_uid: event.data.fetch(:warning_uid)
            }
          )

          # create transaction warning new record(WriteModels)
          WriteModels::Warning.create!(
            warning_type_id: event.data.fetch(:warning_type_id),
            user_id: event.data.fetch(:user_id),
            transaction_uid: transaction_uid,
            warning_uid: event.data.fetch(:warning_uid)
          )
        end
      end
    end
  end
end