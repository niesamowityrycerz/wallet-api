module ReadModels
  module Transactions 
    module Handlers 
      class OnSettlementTermsAdded
        def call(event)
          transaction_projection = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: event.data.fetch(:transaction_uid))
          transaction_projection.update!( 
            {
              max_date_of_settlement: event.data.fetch(:max_date_of_settlement)
            }
          )
        end
      end
    end
  end
end