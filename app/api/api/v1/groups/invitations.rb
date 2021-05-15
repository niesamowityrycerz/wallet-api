module Api 
  module V1
    module Groups 
      class Invitations < Base 
        
        before do 
          authenticate_user!
        end

        desc 'Lists all waiting invitations'

        resource :invitations do 
          get do 
            invitations = ::Groups::InvitationService.invitations(current_user)
            ::Groups::InvitationToGroupSerializer.new(invitations).serializable_hash
          end
        end
      end
    end
  end
end