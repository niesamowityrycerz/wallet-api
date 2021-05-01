module ReadModels
  module Debts
    module Handlers
      class OnDebtDetailsCorrected
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          
          fields = event.data.except(:debt_uid, :state)
          fields.each do |key, value|
            debt_projection.update!(
              { key => value }
            )
          end
        end
      end
    end
  end
end