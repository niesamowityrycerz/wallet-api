module Api
  module V1
    module Users
      class Index < Api::V1::Users::Base 

        desc 'Get user by id'

        route_param :user_id, type: Integer, values: -> { User.ids } do 
          get do
            user = User.find_by!(id: params[:user_id])            
            if current_user.nil?
              ::Users::BaseProfileSerializer.new(user).serializable_hash
            elsif params[:user_id] == current_user.id 
              redirect '/api/v1/me'
            else 
              ::Users::PublicProfileSerializer.new(user, params: { profile_visitor: current_user } ).serializable_hash
            end
          end
        end
      end
    end
  end
end