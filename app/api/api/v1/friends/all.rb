module Api 
  module V1
    module Friends 
      class All < Base 

        before do 
          authenticate_user!
        end

        desc 'Show all friends'

        resource :all do 
          get do 
            friendships = ::Friends::FriendService.call(current_user)
            ::Friendships::FriendsSerializer.new(friendships, params: { current_user: current_user }).serializable_hash
          end
        end
      end
    end
  end
end