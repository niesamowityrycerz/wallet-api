module Api 
  module V1 
    module Friends 
      class Reject < Base 

        before do 
          authenticate_user!
        end

        desc 'Reject friendship'

        params do 
          requires :wanabe_friend_id, type: Integer, values: -> { User.ids }
        end

        resource :reject do 
          patch do
            current_user_friendships = ::Service::Friends::RejectFriendshipService.new(current_user, params)
            if current_user_friendships.has_friend_request?
              current_user_friendships.decline_friend
              status 200
            else  
              status 403
            end
          end
        end
      end
    end
  end
end