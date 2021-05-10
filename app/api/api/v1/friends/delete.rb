module Api
  module V1 
    module Friends 
      class Delete < Base 
      
        before do 
          authenticate_user!
        end

        desc 'Delete friend'

        params do 
          requires :friend_id, type: Integer, values: -> { User.ids }
        end

        # compare delete.rb with reject.rb in terms of using services 
        resource :delete do 
          delete do 
            delete_friend = User.find_by!(id: params[:friend_id])
            if !friendship_errors
              current_user.remove_friend(deleted_friend) 
              status 200
            end 
          end
        end
      end
    end
  end
end