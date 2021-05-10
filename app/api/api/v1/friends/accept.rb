module Api
  module V1 
    module Friends 
      class Accept < Base 

        desc 'Accept friend'

        params do 
          requires :issuer_id, type: Integer, values: -> { User.ids }
        end

        resource :accept do 
          patch do 
            request_issuer = User.find_by!(id: params[:issuer_id])
            if current_user.requested_friends.include? request_issuer
              current_user.accept_request(request_issuer)
              status 200
            else 
              status 404
            end
          end
        end 
      end
    end
  end
end