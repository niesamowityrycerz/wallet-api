module ReadModels
  module Warnings
    module Handlers
      class OnMissedDebtRepaymentWarningSent
        def call(event)
          debt_uid = event.data.fetch(:debt_uid)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update!(
            {
              status: event.data.fetch(:status)
            }
          )
          
          warning_type = WarningType.find_by!(id: event.data.fetch(:warning_type_id))
          ReadModels::Warnings::DebtWarningProjection.create!(
            {
              user_id: event.data.fetch(:user_id),
              warning_type_name: warning_type.name,
              debt_uid: debt_uid,
              warning_uid: event.data.fetch(:warning_uid)
            }
          )

          WriteModels::Warning.create!(
            warning_type_id: event.data.fetch(:warning_type_id),
            user_id: event.data.fetch(:user_id),
            debt_uid: debt_uid,
            warning_uid: event.data.fetch(:warning_uid)
          )
        end
      end
    end
  end
end