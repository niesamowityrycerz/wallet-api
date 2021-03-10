require 'aggregate_root'

module Transactions
  class TransactionAggregate
    include AggregateRoot

    MaximumDateOfTransactionSettlementUnavailable = Class.new(StandardError)
    RepaymentTypeUnavaiable = Class.new(StandardError)
    CurrencyUnavaiable = Class.new(StandardError)

    attr_accessor :repayment_conditions

    def initialize(id)
      @id = id
      @state = nil
      @repayment_conditions = nil
      @due_money = nil
      @date_of_placement = nil
      @maturity_in_days = nil
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
          settlement_method_id: params[:creditor_conditions][:settlement_method_id]
        }.compact
      )
    end

    def accept_transaction
      apply Events::TransactionAccepted.strict(
        {
          transaction_uid: @id,
          status: :accepted
        }
      )
    end

    def reject_transaction
      apply Events::TransactionRejected.strict(
        {
          transaction_uid: @id,
          status: :rejected
        }
      )

      apply Events::CreditorInformed.strict(
        {
          transaction_uid: @id,
          creditor_informed: true 
        }
      )
    end

    def add_settlement_terms(params)
      raise MaximumDateOfTransactionSettlementUnavailable.new 'Date of transaction settlement invalid' unless @repayment_conditions.maturity_date_valid?(params[:max_date_of_settlement], @date_of_placement, @maturity_in_days)
      raise RepaymentTypeUnavaiable.new 'Repayment method is unavailable' unless @repayment_conditions.settlement_method_allowed?(params[:settlement_method_id])
      raise CurrencyUnavaiable.new 'Currency is unavailable' unless @repayment_conditions.currency_allowed?(params[:currency_id]) 

      apply Events::SettlementTermsAdded.strict(
        {
          transaction_uid: @id,
          max_date_of_settlement: params[:max_date_of_settlement]
        }
      )
    end

    def close_transaction(params)
      apply Events::TransactionClosed.strict(
        {
          transaction_uid: @id,
          status: :closed,
          reason_for_closing: params[:reason_for_closing]
        }
      )
    end

    def check_out_transaction(params)
      apply Events::TransactionCheckedOut.strict(
        {
          transaction_uid: @id,
          doubts: params[:doubts],
          status: :under_scrutiny 
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
          status: :corrected
        }.compact
      )
    end

    def settle(params)
      raise InvalidAmount.new 'Not enough!' unless params[:amount] == @due_money
      # warning when transaction settled after predefined date

      apply Events::TransactionSettled.strict(
        {
          transaction_uid: @id,
          amount: params[:amount],
          date_of_settlement: params[:date_of_settlement],
          status: :settled,
          debtor_id: params[:debtor_id],
          creditor_id: @creditor_id
        }
      )
    end

    # "To restore the state of your aggregate you need to use AggregateRoot::Repository."
    # AggregateRoot::Repository.new.load(Transactions::TransactionAggregate.new(need to fulfill id), stream_name of events I want to restore)
    on Events::TransactionIssued do |event|
      @state = :initialized
      @due_money = event.data.fetch(:amount)
      @maturity_in_days = event.data.fetch(:maturity_in_days)
      @date_of_placement = Date.today
      @creditor_id = event.data.fetch(:creditor_id)
    end

    on Events::TransactionAccepted do |event| 
      @status = event.data.fetch(:status)
    end

    on Events::SettlementTermsAdded do |event|
      @status = :settlement_terms_added
    end

    on Events::TransactionRejected do |event| 
      @status = event.data.fetch(:status)
    end

    on Events::CreditorInformed do |event|
      @status = event.data.fetch(:creditor_informed)
    end

    on Events::TransactionClosed do |event|
      @status = event.data.fetch(:status)
    end

    on Events::TransactionCheckedOut do |event|
      @state = event.data.fetch(:status)
    end

    on Events::TransactionCorrected do |event|
      @state = event.data.fetch(:status)
    end

    on Events::TransactionSettled do |event|
      @status = event.data.fetch(:status)
    end
  end
end