module Groups 
  class RejectInvitationService < BaseGroupService
    def call(params, current_user)
      adjusted_parameters = adjust_parameters(params, current_user)
      prepare_command(adjusted_parameters)
    end

    private 

    def adjust_parameters(data)
      data.merge!({
        user_id: current_user.id
      })
    end

    def prepare_command(data)
      @reject_invitation_command = ::Groups::Commands::RejectInvitation.send(data)
    end

    attr_reader :reject_invitation_command
  end
end