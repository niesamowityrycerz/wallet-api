module Api 
  module V1 
    module Friends 
      class Reject < Base 

        before do 
          authenticate_user!

        end

        desc 'Reject friendship'

        resource :reject do 
          put do
            current_user_friendships = ::Friends::RejectFriendshipService.new(current_user, params)
            if current_user_friendships.has_friend_request?
              current_user_friendships.decline_friend
              status 200
            elsif 
              error!('Unable to proceed', 404)
            end
          end
        end
      end
    end
  end
end