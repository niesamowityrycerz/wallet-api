module Api 
  module V1 
    module Friends 
      class Reject < Base 

        before do 
          authenticate_user!
        end

        desc 'Reject friendship'

        params do 
          requires :wanabe_friend_id, type: Integer #, values: ::User.ids
        end

        resource :reject do 
          post do 
            wanabe_friend = User.find_by!(id: params[:wanabe_friend_id])
            if current_user.requested_friends.include? wanabe_friend
              current_user.decline_request(wanabe_friend)
              status 200
            else  
              error!('Operation not permitted')
            end
          end
        end
      end
    end
  end
end