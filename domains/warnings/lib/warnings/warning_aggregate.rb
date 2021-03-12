require 'aggregate_root'

module Warnigs
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
          status: :warning_sent
        }
      )
    end

    on TransactionExpiredWarningSent do |event|
      @status = event.data.fetch(:status)
    end


  end
end