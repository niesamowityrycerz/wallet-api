module Api 
  module V1 
    module Groups
      class AcceptInvitation < Base 

        before do 
          authenticate_user!
        end

        desc 'Accept invitation to group'

        resource :accept do 
          patch do 
            group = ::Groups::AcceptInvitationService.new(params, current_user)
            if group.has_invited? current_user
              group.accept_invitation
              status 201
            else 
              error!('You cannot do that!', 403)
            end
          end
        end 
      end
    end
  end
end