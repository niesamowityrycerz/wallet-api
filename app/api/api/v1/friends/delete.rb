module Api
  module V1 
    module Friends 
      class Delete < Base 
      
        before do 
          authenticate_user!
        end

        desc 'Delete friend'

        # compare delete.rb with reject.rb in terms of using services 
        resource :delete do 
          delete do 
            to_remove = User.find_by!(id: params[:user_id])
            if !friendship_errors
              current_user.remove_friend(to_remove) 
              status 200
            end 
          end
        end
      end
    end
  end
end