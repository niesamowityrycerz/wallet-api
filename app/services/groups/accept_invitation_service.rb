module Groups 
  class AcceptInvitationService < BaseGroupService
    def call(params, current_user)
      adjusted_parameters = adjust_parameters(params, current_user)
      prepare_command(adjusted_parameters)
    end

    private 

    def adjust_parameters(data)
      data.merge!({
        member_id: current_user.id
      })
    end

    def prepare_command(data)
      @accept_invitation_command = ::Groups::Commands::AcceptInvitation.send(data)
    end

    attr_reader :accept_invitation_command
  end
end