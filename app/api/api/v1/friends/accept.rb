module Api
  module V1 
    module Friends 
      class Accept < Base 

        desc 'Accept friend'

        params do 
          requires :issuer_id, type: Integer#, values: ::User.all.ids
        end

        resource :accept do 

          post do 
            request_issuer = User.find_by!(id: params[:issuer_id])
            if current_user.requested_friends.include? request_issuer
              current_user.accept_request(request_issuer)
              status 200
            else 
              error!('You do not have request from this user!', 404)
            end
          end

        end 
      end
    end
  end
end