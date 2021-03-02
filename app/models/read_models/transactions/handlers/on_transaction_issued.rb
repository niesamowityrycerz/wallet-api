module ReadModels
  module Transactions 
    module Handlers
      class OnTransactionIssued 
        # this creates new object
        # of the TransactionProjection read model
        # by default rails_event_store require handlers to respond to #call method
        def call(event)
          # create new record in transaction_projections tables
          binding.pry
          ReadModels::Transactions::TransactionProjection.create(
            {
              issuer_id: event.data[:issuer_id],
              issuer_uid: event.data[:issuer_uid],
              transaction_uid: event.data[:transaction_uid],
              borrower_name: event.data[:borrower_name],
              amount: event.data[:amount]
            }
          )
        end

      end
    end
  end
end