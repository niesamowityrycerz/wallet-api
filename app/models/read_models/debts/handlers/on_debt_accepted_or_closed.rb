module ReadModels
  module Debts 
    module Handlers 
      class OnDebtAcceptedOrClosed
        def call(event)
          debt_projection = ReadModels::Debts::DebtProjection.find_by!(debt_uid: event.data.fetch(:debt_uid))
          debt_projection.update!(
            {
              status: event.data.fetch(:state),
              reason_for_closing: ( event.data.fetch(:reason_for_closing) if event.data.key?(:reason_for_closing) )
            }.compact
          )
        end
      end
    end
  end
end