module ReadModels
  module Groups 
    module Handlers 
      class OnGroupSettlementTermsAdded 
        def call(event)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: event.data.fetch(:group_uid))
          group_p.update({
            debt_repayment_valid_till: event.data.fetch(:debt_repayment_valid_till),
            currency: Currency.find_by!(id: event.data.fetch(:currency_id)).code,
            status: event.data.fetch(:status)
          })

        end
      end
    end
  end
end