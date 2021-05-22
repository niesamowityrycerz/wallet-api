module ReadModels
  module Debts 
    module Handlers
      class OnRepaymentConditionsOverwrote 
        def call(event)
          debt_uid = event.data.fetch(:debt_uid)

          debt_p = ReadModels::Debts::DebtProjection.find_by!(debt_uid: debt_uid)
          debt_p.update!({
            currency_id: event.data.fetch(:currency_id),
            max_date_of_settlement: event.data.fetch(:max_date_of_settlement)
          })
        end
      end
    end
  end
end