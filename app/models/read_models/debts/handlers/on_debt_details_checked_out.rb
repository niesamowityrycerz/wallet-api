module ReadModels
  module Debts
    module Handlers
      class OnDebtDetailsCheckedOut 
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update!(
            {
              doubts: event.data.fetch(:doubts),
              status: event.data.fetch(:status)
            }
          )
        end
      end
    end
  end
end