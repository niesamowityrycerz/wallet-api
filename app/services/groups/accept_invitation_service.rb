module Groups 
  class AcceptInvitationService < BaseGroupService
    def accept_invitation
      Rails.configuration.command_bus.call(
        ::Groups::Commands::AcceptInvitation.send(adjust_params)
      )
    end

    private

    def adjust_params 
      params.merge!({
        member_id: current_user.id
      })
    end
  end
end