require 'aggregate_root'

module Transactions
  class TransactionAggregate
    include AggregateRoot

    class BasicRepaymentConditionsDoNotExist < StandardError; end 

    attr_accessor :repayment_conditions

    def initialize(id)
      @id = id
      @state = nil
      @repayment_conditions = nil 
    end

    def place(params)
      raise BasicRepaymentConditionsDoNotExist.new 'You have to set basic repayment conditions first!' unless !@repayment_conditions.nil? 

      apply Events::TransactionIssued.strict( 
        { 
          creditor_id: params[:creditor_id],
          debtor_id: params[:debtor_id],
          amount: params[:amount],
          transaction_uid: @id,
          description: params[:description],
          currency_id: params[:currency_id],
          date_of_transaction: params[:date_of_transaction],
          maturity: params[:creditor_conditions][:maturity_in_days],
          interest: params[:creditor_conditions][:interest]
        }
      )
    end

    def accept_transaction
      apply Events::TransactionAcceptedRejectedPending.strict(
        {
          transaction_uid: @id,
          status: :accepted
        }
      )
    end

    def set_liquidate_conditions(params)
      raise MaximumDateOfTransactionSettlementUnavailable.new 'Date of transaction settlement invalid' unless @repayment_conditions.maturity_date_valid?(params[:max_date_of_settlement])
      raise RepaymentTypeUnavaiable.new 'Repayment method is unavailable' unless @repayment_conditions.settlement_method_allowed?(params[:repayment_type_id])
      raise CurrencyUnavaiable.new 'Currency is unavailable' unless @repayment_conditions.currency_allowed?(params[:currency_id]) 

      apply Events::SettlementTermsAdded.strict(
        {
          transaction_uid: @uid,
          max_date_of_settlement: params[:max_date_of_settlement],
          repayment_type_id: params[:repayment_type_id]
        }
      )

      apply Events::TransactionReadyToBeSettled.strict(
        {
          transaction_uid: @uid,
          status: :ready_to_be_settled
        }
      )
    end

    # "To restore the state of your aggregate you need to use AggregateRoot::Repository."
    # AggregateRoot::Repository.new.load(Transactions::TransactionAggregate.new(need to fulfill id), stream_name of events I want to restore)
    on Events::TransactionIssued do |event|
      @state = :initialized

    end

    on Events::TransactionAcceptedRejectedPending do |event| 
      @status = event.data.fetch(:status)
    end

    on Events::SettlementTermsAdded do |event|
      @status = :settlement_terms_added
    end

    on Events::SettlementTermsAdded do |event|
      @status = :ready_to_be_settled
    end

  end
end