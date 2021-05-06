module ReadModels
  module Debts
    module Handlers
      class OnDebtIssued 
        def call(event)

          ReadModels::Debts::DebtProjection.create!(
            {
              creditor_id: event.data.fetch(:creditor_id),
              debtor_id: event.data.fetch(:debtor_id),
              debt_uid: event.data.fetch(:debt_uid),
              amount: event.data.fetch(:amount),
              currency_id: event.data.fetch(:currency_id),
              description: event.data.fetch(:description),
              max_date_of_settlement: event.data.fetch(:max_date_of_settlement),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
              status: event.data.fetch(:state),
              group_uid: ( event.data.fetch(:group_uid) if event.data.key?(:group_uid) )
            }.compact
          )

          WriteModels::Debt.create!(
            {
              debtor_id:   event.data.fetch(:debtor_id),   
              creditor_id: event.data.fetch(:creditor_id),
              amount:      event.data.fetch(:amount),
              debt_uid:    event.data.fetch(:debt_uid),
              date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) )
            }
          )

          if event.data.key?(:group_uid)
            event_store.link(
              event.event_id,
              stream_name: stream_name(event.data.fetch(:group_uid)),
              expected_version: :auto
            )
          end

        end

        private 

        def stream_name(group_uid)
          "Group$#{group_uid}"
        end

        def event_store 
          Rails.configuration.event_store 
        end
      end
    end
  end
end