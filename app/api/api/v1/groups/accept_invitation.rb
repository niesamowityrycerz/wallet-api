module Api 
  module V1 
    module Groups
      class AcceptInvitation < Base 

        before do 
          authenticate_user!
        end

        desc 'Accept invitation to group'

        patch do 
          group = ::Groups::AcceptInvitationService.call(params, current_user)
          if group.has_member? current_user
            Rails.configuration.command_bus.call(group.accept_invitation_command)
            status 201
          else 
            status 403
          end
        end
      end
    end
  end
end