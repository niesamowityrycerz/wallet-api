module Api 
  module V1
    module Groups 
      class GroupPanel < Base 

        before do 
          authenticate_user!
        end

        desc 'User group panel'

        get do 
          
        end
      end
    end
  end
end