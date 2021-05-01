require 'aggregate_root'

module Warnings
  class WarningAggregate
    include AggregateRoot

    def initialize(id)
      @id = id
      @state = nil
    end

    def missed_repayment(params)
      apply Events::MissedDebtRepaymentWarningSent.strict(
        {
          debt_uid: @id,
          state: :expired,
          user_id: params[:debtor_id],
          warning_type_id: params[:warning_type_id],
          warning_uid: params[:warning_uid]
        }
      )
    end

    on Events::MissedDebtRepaymentWarningSent do |event|
      @state = event.data.fetch(:state)
    end



  end
end