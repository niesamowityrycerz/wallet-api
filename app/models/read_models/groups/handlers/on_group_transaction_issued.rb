module ReadModels
  module Groups 
    module Handlers 
      class OnGroupTransactionIssued 
        def call(event)
          ReadModels::Groups::GroupTransactionProjection.create!({
            creditor_id: event.data.fetch(:creditor_id),
            debtors_ids: event.data.fetch(:debtors_ids),
            description: event.data.fetch(:description),
            total_amount: event.data.fetch(:total_amount),
            due_money_per_debtor: event.data.fetch(:due_money_per_debtor),
            currency_id: event.data.fetch(:currency_id),
            date_of_transaction: ( data.fetch(:date_of_transaction) if data.key?(:date_of_transaction) ),
            group_uid: event.data.fetch(:group_uid),
            state: :init
          })
        end
      end
    end
  end
end