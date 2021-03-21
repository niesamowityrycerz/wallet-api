require 'aggregate_root'

module Warnings
  class WarningAggregate
    include AggregateRoot

    def initialize(id)
      @id = id
      @status = nil
    end

    def send_expiration_warning(params)
      apply Events::TransactionExpiredWarningSent.strict(
        {
          transaction_uid: @id,
          status: :expired,
          user_id: params[:debtor_id],
          warning_type_id: params[:warning_type_id],
          warning_uid: params[:warning_uid]
        }
      )
    end

    on Events::TransactionExpiredWarningSent do |event|
      @status = event.data.fetch(:status)
    end



  end
end