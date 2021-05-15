module Groups 
  class RegisterGroupService < BaseGroupService
    def register
      Rails.configuration.command_bus.call(
        ::Groups::Commands::RegisterGroup.send(adjust_params)
      )
    end

    private

    def adjust_params
      params.merge!({
        leader_id: current_user.id,
        group_uid: SecureRandom.uuid
      })
    end
  end
end