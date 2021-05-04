module ReadModels
  module Debts 
    module Handlers
      class OnDebtRejected 
        def call(event)
          debt_uid = event.data.fetch(:debt_uid)

          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
          debt_projection.update!({
            status: event.data.fetch(:state),
            reason_for_rejection: event.data.fetch(:reason_for_rejection)
          })

          debt = WriteModels::Debt.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt.update!({
            state: event.data.fetch(:state)
          })
        end
      end
    end
  end
end