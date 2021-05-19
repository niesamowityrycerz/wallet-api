module Debts 
  class IssueDebtService 

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    attr_reader :params
    
    def issue
      adjust_params(@current_user)
      send_command
    end

    private 

    def adjust_params(current_user)
      @params.merge!({
        debt_uid: SecureRandom.uuid,
        creditor_id: current_user.id
      })
    end

    def send_command
      Rails.configuration.command_bus.call(
        ::Debts::Commands::IssueDebt.new(@params)
      )
    end
  end
end