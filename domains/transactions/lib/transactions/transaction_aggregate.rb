require 'aggregate_root'

module Transactions
  class TransactionAggregate
    include AggregateRoot

    AnticipatedDateOfSettlementInvalid = Class.new(StandardError)
    RepaymentTypeUnavaiable            = Class.new(StandardError)
    CurrencyUnavaiable                 = Class.new(StandardError)
    InvalidAmount                      = Class.new(StandardError)

    attr_accessor :repayment_conditions, :due_money

    def initialize(id)
      @id = id
      @state = nil
      @repayment_conditions = nil
      @due_money = nil
      @date_of_placement = nil
      @maturity_in_days = nil
      @expire_on = nil 
      @creditor_id = nil
      @debtor_id = nil 
      
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
          maturity_in_days: params[:creditor_conditions][:maturity_in_days],
          settlement_method_id: params[:creditor_conditions][:settlement_method_id],
          state: :pending
        }.compact
      )
    end

    def accept_transaction
      apply Events::TransactionAccepted.strict(
        {
          transaction_uid: @id,
          state: :accepted,
          expire_on: @expire_on,
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

    def add_settlement_terms(params)
      unless @repayment_conditions.maturity_date_valid?(params[:anticipated_date_of_settlement], @date_of_placement, @maturity_in_days)
        raise AnticipatedDateOfSettlementInvalid.new 'Anticipated date of transaction settlement is invalid'
      end 
      raise RepaymentTypeUnavaiable.new 'Repayment method is unavailable' unless @repayment_conditions.settlement_method_allowed?(params[:debtor_settlement_method_id])
      raise CurrencyUnavaiable.new 'Currency is unavailable' unless @repayment_conditions.currency_allowed?(params[:currency_id]) 

      apply Events::SettlementTermsAdded.strict(
        {
          transaction_uid: @id,
          anticipated_date_of_settlement: params[:anticipated_date_of_settlement],
          state: :debtor_terms_added,
          debtor_id: @debtor_id
        }
      )
    end

    def close_transaction(params)
      apply Events::TransactionClosed.strict(
        {
          transaction_uid: @id,
          state: :closed,
          reason_for_closing: ( params[:reason_for_closing] if params.key?(:reason_for_closing) )
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
      apply Events::TransactionSettled.strict(
        {
          transaction_uid: @id,
          date_of_settlement: params[:date_of_settlement],
          state: :settled,
          debtor_id: @debtor_id, 
          creditor_id: @creditor_id,
          amount: @due_money,
          expire_on: @expire_on 
        }
      )
    end

    # "To restore the state of your aggregate you need to use AggregateRoot::Repository."
    # AggregateRoot::Repository.new.load(Transactions::TransactionAggregate.new(need to fulfill id), stream_name of events I want to restore)
    on Events::TransactionIssued do |event|
      @state = event.data.fetch(:state)
      @due_money = event.data.fetch(:amount)
      @maturity_in_days = event.data.fetch(:maturity_in_days)
      @date_of_placement = Date.today
      @expire_on = Date.today + event.data.fetch(:maturity_in_days)
      @creditor_id = event.data.fetch(:creditor_id)
      @debtor_id = event.data.fetch(:debtor_id)
      @repayment_conditions = Repositories::RepaymentCondition.new.with_condition(event.data.fetch(:creditor_id))
    end

    on Events::TransactionAccepted do |event| 
      @state = event.data.fetch(:state)
    end

    on Events::SettlementTermsAdded do |event|
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
    end
  end
end