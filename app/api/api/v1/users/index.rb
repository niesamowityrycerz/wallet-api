module Api
  module V1
    module Users
      class Index < Base 

        desc 'Get user by id'

        get do
          user = User.find_by!(id: params[:id]) 
          if current_user.nil?
            ::Users::BaseProfileSerializer.new(user).serializable_hash
          elsif params[:id].to_i == current_user.id 
            redirect '/api/v1/me'
          else 
            ::Users::PublicProfileSerializer.new(user, params: { profile_visitor: current_user } ).serializable_hash
          end
        end
      end
    end
  end
end