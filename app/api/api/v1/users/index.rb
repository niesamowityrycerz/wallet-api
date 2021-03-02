module Api
  module V1
    module Users
      class Index < Base 
        before do 
          authenticate_user!
        end

        desc 'get user by id '
        route_param :id, type: Integer do 
          get do
            #if user_signed_in? 
            #  current_user
            #  200
            #else  
            #  present 'nie działa'
            #end
            current_user
          end
        end
        
      end
    end
  end
end