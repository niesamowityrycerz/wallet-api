module Api
  module V1 
    module Friends 
      class Delete < Base 
      
        before do 
          authenticate_user!
        end

        desc 'Delete friend'

        params do 
          requires :user_id, type: Integer, values: -> { User.ids }
        end

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