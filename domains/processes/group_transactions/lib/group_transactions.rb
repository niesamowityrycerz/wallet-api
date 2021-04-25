module Processes
  class GroupTransactions
    def initialize(event_store=Rails.configuration.event_store,
      command_bus=Rails.configuration.command_bus)
      @command_bus = command_bus
      @event_store = event_store
    end 

    attr_reader :command_bus, :event_store


    def call(event)
      if group_transaction_issued?(event)
        debtors = event.data.fetch(:debtors_ids)
        debtors.each do |debtor_id|
          command_bus.call(
            Transactions::Transaction::IssueTransaction.send(
              {
                transaction_uid: SecureRandom.uuid,
                creditor_id: event.data.fetch(:creditor_id),
                debtor_id: debtor_id,
                description: event.data.fetch(:description),
                amount: event.data.fetch(:due_money_per_debtor),
                currency_id: event.data.fetch(:currency_id),
                date_of_transaction: ( event.data.fetch(:date_of_transaction) if event.data.key?(:date_of_transaction) ),
                group_transaction: true,
                group_uid: event.data.fetch(:group_uid)
              }
            )
          )
        end 
      end
    end

    private 

    def group_transaction_issued?(event)
      event.data.fetch(:state) == :init
    end

  end
end 