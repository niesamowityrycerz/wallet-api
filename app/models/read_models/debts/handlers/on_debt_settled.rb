module ReadModels
  module Debts
    module Handlers
      class OnDebtSettled 
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update!(
            {
              date_of_settlement: event.data.fetch(:date_of_settlement),
              status: event.data.fetch(:status)
            }
          )

          debt = WriteModels::Debt.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt.update!({
            status: event.data.fetch(:status)
          })
        end
      end
    end
  end
end