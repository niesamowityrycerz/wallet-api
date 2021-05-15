module Debts 
  class AddAnticipatedSettlementDateService < BaseDebtsService
    def set_aniticipated_date
      Rails.configuration.command_bus.call(
        Debts::Commands::AddAnticipatedSettlementDate.new(adjusted_params)
      )
    end

    private 

    def adjusted_params
      params.merge({
        debtor_id: current_user.id
      })
    end
  end
end