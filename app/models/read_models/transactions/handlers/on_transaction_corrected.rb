module ReadModels
  module Transactions
    module Handlers
      class OnTransactionCorrected
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          
          fields = event.data.except(:transaction_uid, :state)
          fields.each do |key, value|
            transaction_projection.update!(
              { key => value }
            )
          end
        end
      end
    end
  end
end