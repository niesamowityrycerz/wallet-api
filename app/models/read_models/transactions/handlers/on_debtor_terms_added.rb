module ReadModels
  module Transactions 
    module Handlers 
      class OnDebtorTermsAdded
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!( 
            {
              status: event.data.fetch(:state),
              anticipated_date_of_settlement: event.data.fetch(:anticipated_date_of_settlement),
              settlement_method_id: event.data.fetch(:debtor_settlement_method_id)
            }
          )
        end
      end
    end
  end
end