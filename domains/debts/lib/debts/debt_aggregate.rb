require 'aggregate_root'

module Debts
  class DebtAggregate
    include AggregateRoot

    AnticipatedDateOfSettlementUnavailable = Class.new(StandardError)
    DebtNotAccepted                        = Class.new(StandardError)
    UnableToProceedSettleement             = Class.new(StandardError)
    UnableToCheckOutDebtDetails            = Class.new(StandardError)
    UnableToCorrectDebtDetails             = Class.new(StandardError)
    UnableToAccept                         = Class.new(StandardError)

    attr_accessor :repayment_conditions, :due_money

    def initialize(id)
      @id = id
      @status = nil
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
          group_uid: ( params[:group_uid] if params.key?(:group_uid) )
        }.compact
      )
    end

    def accept
      raise UnableToAccept.new 'You cannot do that!' unless @status == :pending

      apply Events::DebtAccepted.strict(
        {
          debt_uid: @id,
          status: :accepted,
          expire_on: @max_date_of_settlement,
          debtor_id: @debtor_id
        }
      )
    end

    def reject(params)
      apply Events::DebtRejected.strict(
        {
          debt_uid: @id,
          status: :rejected,
          reason_for_rejection: params[:reason_for_rejection]
        }
      )
    end

    def add_anticipated_settlement_date(params)
      raise DebtNotAccepted.new 'Accept debt first!' unless @status == :accepted
      raise AnticipatedDateOfSettlementUnavailable.new 'Date unavailable' unless params[:anticipated_date_of_settlement] <= @max_date_of_settlement

      apply Events::AnticipatedSettlementDateAdded.strict(
        {
          debt_uid: @id,
          anticipated_date_of_settlement: params[:anticipated_date_of_settlement],
          status: :anticipated_settlement_date_added,
        }
      )
    end

    def close(params)
      apply Events::DebtClosed.strict(
        {
          debt_uid: @id,
          status: :closed,
          reason_for_closing: ( params[:reason_for_closing] if params.key?(:reason_for_closing) ),
          creditor_id: @creditor_id
        }.compact
      )
    end

    def check_out_details(params)
      raise UnableToCheckOutDebtDetails.new 'This option is unavailable after debt acceptance.' unless @status == :pending

      apply Events::DebtDetailsCheckedOut.strict(
        {
          debt_uid: @id,
          doubts: params[:doubts],
          status: :under_scrutiny 
        }
      )
    end

    def correct_details(params)
      raise UnableToCorrectDebtDetails.new 'This option is unavailable.' unless @status == :under_scrutiny

      apply Events::DebtDetailsCorrected.strict(
        {
          debt_uid: params[:debt_uid],
          amount: ( params[:amount] if params.key?(:amount) ),
          description: ( params[:description] if params.key?(:description) ),
          currency_id: ( params[:currency_id] if params.key?(:currency_id) ),
          date_of_transaction: ( params[:date_of_transaction] if params.key?(:date_of_transaction) ),
          status: :corrected
        }.compact
      )
    end

    def settle(params)
      raise UnableToProceedSettleement.new 'You have to accept debt before settlement!' unless [ :accepted, :anticipated_settlement_date_added ].include? @status 

      apply Events::DebtSettled.strict(
        {
          debt_uid: @id,
          date_of_settlement: Date.today,
          status: :settled,
          debtor_id: @debtor_id, 
          creditor_id: @creditor_id,
          amount: @due_money,
          expire_on: @max_date_of_settlement 
        }
      )
    end

    on Events::DebtIssued do |event|
      @status = :pending
      @due_money = event.data.fetch(:amount)
      @date_of_placement = Date.today
      @creditor_id = event.data.fetch(:creditor_id)
      @debtor_id = event.data.fetch(:debtor_id)
      @repayment_conditions = Repositories::RepaymentCondition.new.with_condition(event.data.fetch(:creditor_id)) unless event.data.key?(:group_uid)
      @max_date_of_settlement = event.data.fetch(:max_date_of_settlement) 
    end

    on Events::DebtAccepted do |event| 
      @status = event.data.fetch(:status)
    end

    on Events::AnticipatedSettlementDateAdded do |event|
      @status = event.data.fetch(:status)
    end

    on Events::DebtRejected do |event| 
      @status = event.data.fetch(:status)
    end

    on Events::DebtClosed do |event|
      @status = event.data.fetch(:status)
    end

    on Events::DebtDetailsCheckedOut do |event|
      @status = event.data.fetch(:status)
    end

    on Events::DebtDetailsCorrected do |event|
      @status = event.data.fetch(:status)
    end

    on Events::DebtSettled do |event|
      @status = event.data.fetch(:status)
      @date_of_settlement = event.data.fetch(:date_of_settlement)
    end
  end
end