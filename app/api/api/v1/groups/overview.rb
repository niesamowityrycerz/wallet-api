module Api 
  module V1 
    module Groups 
      class Overview < Base 

        before do 
          authenticate_user!
        end

        desc 'Present groups to which current user belongs or belonged'

        resource :overview do 
          get do 
            

          end
        end 
      end
    end
  end 
end