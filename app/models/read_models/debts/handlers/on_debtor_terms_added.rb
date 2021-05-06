module ReadModels
  module Debts
    module Handlers 
      class OnDebtorTermsAdded
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update!( 
            {
              status: event.data.fetch(:state),
              anticipated_date_of_settlement: event.data.fetch(:anticipated_date_of_settlement)
            }
          )
        end
      end
    end
  end
end