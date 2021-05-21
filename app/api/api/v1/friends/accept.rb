module Api
  module V1 
    module Friends 
      class Accept < Base 

        desc 'Accept friend'

        resource :accept do 
          put do 
            request_issuer = User.find_by!(id: params[:user_id])
            if current_user.requested_friends.include? request_issuer
              current_user.accept_request(request_issuer)
              status 200
            else 
              error!('Unable to proceed', 404)
            end
          end
        end 
      end
    end
  end
end