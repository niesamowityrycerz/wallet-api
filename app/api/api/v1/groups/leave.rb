module Api 
   module V1 
    module Groups 
      class Leave < Base 

        before do 
          authenticate_user!
        end

        desc 'Leave group'

        resource :leave do 
          post do 
            group = ::Groups::LeaveGroupService.new(params, current_user)
            if group.has_member? current_user
              group.leave
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