module ReadModels
  module Debts
    module Handlers
      class OnDebtDetailsCorrected
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          
          debt_projection.update!(
            {   
              amount: ( event.data.fetch(:amount) if event.data.key?(:amount) ),
              description: ( event.data.fetch(:description) if event.data.key?(:description) ),
              currency_id: ( event.data.fetch(:currency_id) if event.data.key?(:currency_id) ),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
            }.compact
          )
        end
      end
    end
  end
end