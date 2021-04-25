require 'aggregate_root'

module Transactions
  class TransactionAggregate
    include AggregateRoot

    AnticipatedDateOfSettlementUnavailable = Class.new(StandardError)
    RepaymentTypeUnavaiable                = Class.new(StandardError)
    CurrencyUnavaiable                     = Class.new(StandardError)
    InvalidAmount                          = Class.new(StandardError)
    TransactionNotAccepted                 = Class.new(StandardError)
    DebtorTermsNotAdded                    = Class.new(StandardError)

    attr_accessor :repayment_conditions, :due_money

    def initialize(id)
      @id = id
      @state = nil
      @repayment_conditions = nil
      @due_money = nil
      @due_money_per_memeber = nil
      @date_of_placement = nil
      @max_date_of_settlement = nil
      @date_of_settlement = nil
      @creditor_id = nil
      @debtor_id = nil
      @group_uid = nil 
      
    end

    def place(params)

      apply Events::TransactionIssued.strict( 
        { 
          creditor_id: params[:creditor_id],
          debtor_id: params[:debtor_id],
          amount: params[:amount],
          transaction_uid: @id,
          description: params[:description],
          currency_id: params[:currency_id],
          date_of_transaction: ( params[:date_of_transaction] if params.key?(:date_of_transaction) ),
          settlement_method_id: ( params[:creditor_conditions][:settlement_method_id] if params.key?(:creditor_conditions) ),
          max_date_of_settlement: ( params.key?(:creditor_conditions) ? Date.today + params[:creditor_conditions][:maturity_in_days] : params[:max_date_of_settlement] ),
          state: :pending,
          group_uid: ( params[:group_uid] if params.key?(:group_uid) ),
          group_transaction: ( params[:group_transaction] if params.key?(:group_transaction) )
        }.compact
      )
    end

    def accept_transaction
      apply Events::TransactionAccepted.strict(
        {
          transaction_uid: @id,
          state: :accepted,
          expire_on: @max_date_of_settlement,
          debtor_id: @debtor_id
        }
      )
    end

    def reject_transaction(params)
      apply Events::TransactionRejected.strict(
        {
          transaction_uid: @id,
          state: :rejected,
          reason_for_rejection: params[:reason_for_rejection]
        }
      )
    end

    def add_debtor_terms(params)
      raise TransactionNotAccepted.new 'Accept transaction first!' unless @state == :accepted
      raise AnticipatedDateOfSettlementUnavailable.new 'Date unavailable' unless params[:anticipated_date_of_settlement] <= @max_date_of_settlement
      raise RepaymentTypeUnavaiable.new 'Repayment method is unavailable' unless @repayment_conditions.settlement_method_allowed?(params[:debtor_settlement_method_id])

      apply Events::DebtorTermsAdded.strict(
        {
          transaction_uid: @id,
          anticipated_date_of_settlement: params[:anticipated_date_of_settlement],
          state: :debtors_terms_added,
          debtor_settlement_method_id: params[:debtor_settlement_method_id]
        }
      )
    end

    def close_transaction(params)
      apply Events::TransactionClosed.strict(
        {
          transaction_uid: @id,
          state: :closed,
          reason_for_closing: ( params[:reason_for_closing] if params.key?(:reason_for_closing) ),
          creditor_id: @creditor_id
        }.compact
      )
    end

    def check_out_transaction(params)
      apply Events::TransactionCheckedOut.strict(
        {
          transaction_uid: @id,
          doubts: params[:doubts],
          state: :under_scrutiny 
        }
      )
    end

    def correct_transaction(params)
      apply Events::TransactionCorrected.strict(
        {
          transaction_uid: @id,
          amount: ( params[:amount] if params.key?(:amount) ),
          description: ( params[:description] if params.key?(:description) ),
          currency_id: ( params[:currency_id] if params.key?(:currency_id) ),
          date_of_transaction: ( params[:date_of_transaction] if params.key?(:date_of_transaction) ),
          state: :corrected
        }.compact
      )
    end

    def settle(params)
      raise DebtorTermsNotAdded.new 'Fill settlement terms first!' unless @state == :debtors_terms_added
      apply Events::TransactionSettled.strict(
        {
          transaction_uid: @id,
          date_of_settlement: Date.today,
          state: :settled,
          debtor_id: @debtor_id, 
          creditor_id: @creditor_id,
          amount: @due_money,
          expire_on: @max_date_of_settlement 
        }
      )
    end

    # "To restore the state of your aggregate you need to use AggregateRoot::Repository."
    # AggregateRoot::Repository.new.load(Transactions::TransactionAggregate.new(need to fulfill id), stream_name of events I want to restore)
    on Events::TransactionIssued do |event|
      @state = event.data.fetch(:state)
      @due_money = event.data.fetch(:amount)
      @date_of_placement = Date.today
      @creditor_id = event.data.fetch(:creditor_id)
      @debtor_id = event.data.fetch(:debtor_id)
      @repayment_conditions = Repositories::RepaymentCondition.new.with_condition(event.data.fetch(:creditor_id)) unless event.data.key?(:group_transaction)
      @max_date_of_settlement = event.data.fetch(:max_date_of_settlement) 
    end

    on Events::TransactionAccepted do |event| 
      @state = event.data.fetch(:state)
    end

    on Events::DebtorTermsAdded do |event|
      @state = event.data.fetch(:state)
    end

    on Events::TransactionRejected do |event| 
      @state = event.data.fetch(:state)
    end

    on Events::TransactionClosed do |event|
      @state = event.data.fetch(:state)
    end

    on Events::TransactionCheckedOut do |event|
      @state = event.data.fetch(:state)
    end

    on Events::TransactionCorrected do |event|
      @state = event.data.fetch(:state)
    end

    on Events::TransactionSettled do |event|
      @state = event.data.fetch(:state)
      @date_of_settlement = event.data.fetch(:date_of_settlement)
    end
  end
end