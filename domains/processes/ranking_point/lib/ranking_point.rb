module Processes
  class RankingPoint
    def initialize(event_store=Rails.configuration.event_store,
                    command_bus=Rails.configuration.command_bus)
      @command_bus = command_bus
      @event_store = event_store
    end 

    attr_reader :command_bus, :event_store

    # TO JEST SYSTEM
    # deleguje commendy na podstawie przeszlych zdarzeń 

    def call(event)
      if settlement_terms_added?(event)
        # timer
        Warnings::PrepareToSendTransactionExpiredWarning.perform_in(30.seconds, event.data.fetch(:transaction_uid), event.data.fetch(:debtor_id))       
      elsif transaction_settled?(event)

        Warnings::PrepareToSendTransactionExpiredWarning.cancel_warning(event.data.fetch(:transaction_uid))

        command_bus.call(
          CredibilityPoints::Commands::CalculateCredibilityPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid),
              debtor_id: event.data.fetch(:debtor_id),
              due_money: event.data.fetch(:amount)
            }
          )
        )
        command_bus.call(
          TrustPoints::Commands::CalculateTrustPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid),
              creditor_id: event.data.fetch(:creditor_id),
              due_money: event.data.fetch(:amount)
            }
          )
        )
      elsif credibility_points_calculated?(event)
        command_bus.call(
          CredibilityPoints::Commands::AllotCredibilityPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid)
            }
          )
        )
      elsif trust_points_calculated?(event)
        command_bus.call(
          TrustPoints::Commands::AllotTrustPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid)
            }
          )
        )
      elsif transaction_expired?(event)
        # send new warning every 24h 
        Warnings::PrepareToSendTransactionExpiredWarning.perform_in(10.minutes, event.data.fetch(:transaction_uid), event.data.fetch(:user_id)) 
        binding.pry
        command_bus.call(
          CredibilityPoints::Commands::AddPenaltyPoints.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid),
              debtor_id: event.data.fetch(:user_id),
              warning_type_id: event.data.fetch(:warning_type_id),
              warning_uid: event.data.fetch(:warning_uid)
            }
          )
        )
      elsif ranking_points_calculated?(event)
        command_bus.call(
          Transactions::Commands::CloseTransaction.new(
            {
              transaction_uid: event.data.fetch(:transaction_uid)
            }
          )
        )
      end
    end

    private 

    def transaction_settled?(event)
      event.data.fetch(:status) == :settled
    end

    def credibility_points_calculated?(event)
      event.data.fetch(:status) == :credibility_points_calculated
    end

    def trust_points_calculated?(event)
      event.data.fetch(:status) == :trust_points_calculated
    end

    def settlement_terms_added?(event)
      event.data.fetch(:status) == :debtor_terms_added
    end

    def transaction_expired?(event)
      event.data.fetch(:status) == :expired
    end

    def ranking_points_calculated?(event)
      event.data.fetch(:status) == :points_alloted
    end

    # calculate when to send warning 
    def timer(event)
      due_day = event.data.fetch(:max_date_of_settlement)
      today = Date.today 
      # get difference in minutes 
      ((due_day - today)*24*60).to_i 
    end




    
  end
end