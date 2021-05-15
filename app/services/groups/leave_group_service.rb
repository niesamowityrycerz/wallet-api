module Groups 
  class LeaveGroupService < BaseGroupService
    def leave
      Rails.configuration.command_bus.call(
        ::Groups::Commands::LeaveGroup.send(params)
      )
    end
  end
end