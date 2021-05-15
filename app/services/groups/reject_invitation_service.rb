module Groups 
  class RejectInvitationService < BaseGroupService
    def reject_invitation
      Rails.configuration.command_bus.call(
        ::Groups::Commands::RejectInvitation.send(adjust_params)
      )
    end

    private

    def adjust_params
      params.merge!({
        user_id: current_user.id
      })
    end
  end 
end