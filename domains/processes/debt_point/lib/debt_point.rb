module Processes
  class DebtPoint
    def initialize(event_store=Rails.configuration.event_store,
                    command_bus=Rails.configuration.command_bus)
      @command_bus = command_bus
      @event_store = event_store
    end 

    attr_reader :command_bus, :event_store

    def call(event)
      if debt_accepted?(event)
        Warnings::PrepareToSendMissedDebtRepaymentWarning.perform_in(time_to_expire(event), event.data.fetch(:debt_uid), event.data.fetch(:debtor_id))
      elsif debt_settled?(event)
        Warnings::PrepareToSendMissedDebtRepaymentWarning.cancel_warning(event.data.fetch(:debt_uid))
        command_bus.call(
          RankingPoints::Commands::AllotCredibilityPoints.new(
            {
              debt_uid: event.data.fetch(:debt_uid),
              debtor_id: event.data.fetch(:debtor_id),
              due_money: event.data.fetch(:amount),
              expire_on: event.data.fetch(:expire_on)
            }
          )
        )
        command_bus.call(
          RankingPoints::Commands::AllotTrustPoints.new(
            {
              debt_uid: event.data.fetch(:debt_uid),
              creditor_id: event.data.fetch(:creditor_id)
            }
          )
        )
      elsif debt_expired?(event)
        # send new warning every 24h 
        Warnings::PrepareToSendMissedDebtRepaymentWarning.perform_in(24.hours, event.data.fetch(:debt_uid), event.data.fetch(:user_id)) 
        command_bus.call(
          RankingPoints::Commands::AddPenaltyPoints.new(
            {
              debt_uid: event.data.fetch(:debt_uid),
              debtor_id: event.data.fetch(:user_id),
              warning_type_id: event.data.fetch(:warning_type_id),
              warning_uid: event.data.fetch(:warning_uid)
            }
          )
        )
      elsif ranking_points_alloted?(event)
        command_bus.call(
          Debts::Commands::CloseDebt.new(
            {
              debt_uid: event.data.fetch(:debt_uid)
            }
          )
        )
      end
    end

    private 

    def debt_settled?(event)
      event.data.fetch(:state) == :settled
    end

    def debt_expired?(event)
      event.data.fetch(:state) == :expired
    end

    def ranking_points_alloted?(event)
      event.data.fetch(:state) == :points_alloted
    end

    def debt_corrected?(event)
      event.data.fetch(:state) == :corrected 
    end

    def debt_accepted?(event)
      event.data.fetch(:state) == :accepted
    end

    def time_to_expire(event)
      today = Date.today 
      due_day = event.data.fetch(:expire_on)
      today = Date.today 
      ((due_day - today)*24*60).to_i 
    end
  end
end