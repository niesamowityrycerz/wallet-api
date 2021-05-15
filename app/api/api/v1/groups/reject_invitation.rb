module Api 
  module V1 
    module Groups
      class RejectInvitation < Base 

        before do 
          authenticate_user!
        end

        desc 'Reject invitation to group'

        resource :reject do 
          patch do 
            group = ::Groups::RejectInvitationService.new(params, current_user)
            if group.has_invited? current_user
              group.reject_invitation
              status 201
            else 
              status 403
            end
          end
        end 
      end
    end
  end
end