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
            friendships = ::Services::Friends::FriendService.call(current_user)
            ::Users::FriendsSerializer.new(friendships).serializable_hash
            # linki do akceptacji, odrzucenia i usunięcia 
          end
        end
      end
    end
  end
end