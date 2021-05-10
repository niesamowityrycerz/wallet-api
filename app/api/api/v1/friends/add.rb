module Api 
  module V1 
    module Friends
      class Add < Base 

        before do 
          authenticate_user!
          friendship_errors
        end

        desc 'Add friend'

        params do
          requires :friend_id, type: Integer, values: -> { User.ids }
        end

        resource :add do 
          post do 
            requested_user = User.find_by!(id: params[:friend_id])
            if !friendship_errors 
              current_user.friend_request(requested_user)
              status 200
            end
          end
        end
      end
    end
  end
end