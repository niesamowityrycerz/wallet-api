module Api
  module V1
    module Users
      class Index < Base 
        #before do 
        #  authenticate_user!
        #end

        desc 'get user'
        route_param :id, type: Integer do 
          get do
            user = User.find_by!(id: params[:id])
            ::UserSerializer.new(user).serializable_hash
          end
        end
        
      end
    end
  end
end