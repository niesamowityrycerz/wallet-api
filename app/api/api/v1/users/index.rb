module Api
  module V1
    module Users
      class Index < Base 
        before do 
          authenticate_user!
        end

        desc 'get user'
        route_param :id, type: Integer do 
          get do
            current_user
          end
        end
        
      end
    end
  end
end