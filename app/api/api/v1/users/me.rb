module Api
  module V1
    module Users 
      class Me < Base 

        before do 
          authenticate_user!
        end

        desc 'Get logged in user private profile'

        resource :me do 
          get do 
            ::Users::PrivateProfileSerializer.new(current_user).serializable_hash
          end
        end
      end
    end
  end
end