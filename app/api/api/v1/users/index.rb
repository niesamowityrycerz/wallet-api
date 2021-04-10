module Api
  module V1
    module Users
      class Index < Api::V1::Users::Base 
        before do 
          authenticate_user!
        end

        desc 'Get user'
        route_param :id, type: Integer do 
          get do
            if current_user.admin || current_user.id == params[:id]
              user = User.find_by!(id: params[:id])
              ::UserSerializer.new(user).serializable_hash
            else 
              status 403
            end 

          
          end
        end

      end
    end
  end
end