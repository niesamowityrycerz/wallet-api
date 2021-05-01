module ReadModels
  module Groups 
    module Handlers 
      class OnGroupDebtIssued 
        def call(event)
          ReadModels::Groups::GroupDebtProjection.create!({
            issuer_id: event.data.fetch(:issuer_id),
            recievers_ids: event.data.fetch(:recievers_ids),
            description: event.data.fetch(:description),
            total_amount: event.data.fetch(:total_amount),
            due_money_per_reciever: event.data.fetch(:due_money_per_reciever),
            currency: Currency.find_by!(id: event.data.fetch(:currency_id)).code,
            date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
            group_uid: event.data.fetch(:group_uid),
            state: :init
          })
        end
      end
    end
  end
end