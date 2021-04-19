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
            friendships = current_user.friends 
            binding.pry 
            ::Users::FriendsSerializer.new(friendships).serializable_hash
          end
        end

      end
    end
  end
end