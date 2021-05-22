module Api
  module V1 
    module Friends 
      class Accept < Base 

        before do 
          authenticate_user!
        end

        desc 'Accept friend'

        params do 
          requires :user_id, type: Integer, values: -> { User.ids }
        end

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