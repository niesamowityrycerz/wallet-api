require 'aggregate_root'

module Debts
  class DebtAggregate
    include AggregateRoot

    AnticipatedDateOfSettlementUnavailable = Class.new(StandardError)
    CurrencyUnavaiable                     = Class.new(StandardError)
    InvalidAmount                          = Class.new(StandardError)
    DebtNotAccepted                        = Class.new(StandardError)
    DebtorTermsNotAdded                    = Class.new(StandardError)
    UnableToProceedDebtSettleement         = Class.new(StandardError)

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

    def issue(params)
      apply Events::DebtIssued.strict( 
        { 
          creditor_id: params[:creditor_id],
          debtor_id: params[:debtor_id],
          amount: params[:amount],
          debt_uid: @id,
          description: params[:description],
          currency_id: params[:currency_id],
          date_of_transaction: ( params[:date_of_transaction] if params.key?(:date_of_transaction) ),
          max_date_of_settlement: ( params.key?(:creditor_conditions) ? Date.today + params[:creditor_conditions][:maturity_in_days] : params[:max_date_of_settlement] ),
          state: :pending,
          group_uid: ( params[:group_uid] if params.key?(:group_uid) )
        }.compact
      )
    end

    def accept
      apply Events::DebtAccepted.strict(
        {
          debt_uid: @id,
          state: :accepted,
          expire_on: @max_date_of_settlement,
          debtor_id: @debtor_id
        }
      )
    end

    def reject(params)
      apply Events::DebtRejected.strict(
        {
          debt_uid: @id,
          state: :rejected,
          reason_for_rejection: params[:reason_for_rejection]
        }
      )
    end

    def add_debtor_terms(params)
      raise DebtNotAccepted.new 'Accept debt first!' unless @state == :accepted
      raise AnticipatedDateOfSettlementUnavailable.new 'Date unavailable' unless params[:anticipated_date_of_settlement] <= @max_date_of_settlement

      apply Events::DebtorTermsAdded.strict(
        {
          debt_uid: @id,
          anticipated_date_of_settlement: params[:anticipated_date_of_settlement],
          state: :debtor_terms_added,
        }
      )
    end

    def close(params)
      apply Events::DebtClosed.strict(
        {
          debt_uid: @id,
          state: :closed,
          reason_for_closing: ( params[:reason_for_closing] if params.key?(:reason_for_closing) ),
          creditor_id: @creditor_id
        }.compact
      )
    end

    def check_out_details(params)
      apply Events::DebtDetailsCheckedOut.strict(
        {
          debt_uid: @id,
          doubts: params[:doubts],
          state: :under_scrutiny 
        }
      )
    end

    def correct_details(params)
      apply Events::DebtDetailsCorrected.strict(
        {
          debt_uid: @id,
          amount: ( params[:amount] if params.key?(:amount) ),
          description: ( params[:description] if params.key?(:description) ),
          currency_id: ( params[:currency_id] if params.key?(:currency_id) ),
          date_of_transaction: ( params[:date_of_transaction] if params.key?(:date_of_transaction) ),
          state: :corrected
        }.compact
      )
    end

    def settle(params)
      raise UnableToProceedDebtSettleement.new unless @state == ( :accepted || :debtor_terms_added )
      apply Events::DebtSettled.strict(
        {
          debt_uid: @id,
          date_of_settlement: Date.today,
          state: :settled,
          debtor_id: @debtor_id, 
          creditor_id: @creditor_id,
          amount: @due_money,
          expire_on: @max_date_of_settlement 
        }
      )
    end

    on Events::DebtIssued do |event|
      @state = event.data.fetch(:state)
      @due_money = event.data.fetch(:amount)
      @date_of_placement = Date.today
      @creditor_id = event.data.fetch(:creditor_id)
      @debtor_id = event.data.fetch(:debtor_id)
      @repayment_conditions = Repositories::RepaymentCondition.new.with_condition(event.data.fetch(:creditor_id)) unless event.data.key?(:group_uid)
      @max_date_of_settlement = event.data.fetch(:max_date_of_settlement) 
    end

    on Events::DebtAccepted do |event| 
      @state = event.data.fetch(:state)
    end

    on Events::DebtorTermsAdded do |event|
      @state = event.data.fetch(:state)
    end

    on Events::DebtRejected do |event| 
      @state = event.data.fetch(:state)
    end

    on Events::DebtClosed do |event|
      @state = event.data.fetch(:state)
    end

    on Events::DebtDetailsCheckedOut do |event|
      @state = event.data.fetch(:state)
    end

    on Events::DebtDetailsCorrected do |event|
      @state = event.data.fetch(:state)
    end

    on Events::DebtSettled do |event|
      @state = event.data.fetch(:state)
      @date_of_settlement = event.data.fetch(:date_of_settlement)
    end
  end
end