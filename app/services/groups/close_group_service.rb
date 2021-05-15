module Groups 
  class CloseGroupService < BaseGroupService
    def close 
      Rails.configuration.command_bus.call(
        Groups::Commands::CloseGroup.send(adjust_params)
      )
    end

    private 

    def adjust_params
      params.merge({
        leader_id: current_user.id
      })
    end
  end
end