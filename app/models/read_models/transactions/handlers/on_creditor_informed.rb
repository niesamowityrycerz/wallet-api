module ReadModels
  module Transactions
    module Handlers 
      class OnCreditorInformed
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!(
            {
              creditor_informed: event.data.fetch(:creditor_informed)
            }
          )
        end
      end
    end
  end
end