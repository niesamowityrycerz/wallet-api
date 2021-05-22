module Api
  module V1 
    module Groups 
      class Close < Base 

        before do 
          authenticate_user!
        end

        desc 'Close group'

        resource :close do 
          put do 
            group = ::Groups::CloseGroupService.new(params, current_user)
            if group.is_leader? current_user
              group.close
              status 200
            else 
              error!('You cannot do that!', 403)
            end
          end
        end
      end
    end
  end
end