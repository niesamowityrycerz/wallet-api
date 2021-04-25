module ReadModels
  module Groups 
    module Handlers 
      class OnGroupSettlementTermsAdded 
        def call(event)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: event.data.fetch(:group_uid))

          group_p.update({
            transaction_expired_on: event.data.fetch(:transaction_expired_on),
            currency: Currency.find_by!(id: event.data.fetch(:currency_id)),
            state: event.data.fetch(:state)
          })

        end
      end
    end
  end
end