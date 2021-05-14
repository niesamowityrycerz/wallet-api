module Api 
  module V1 
    module Groups 
      class Index < Base 

        before do 
          authenticate_user!
        end

        desc 'Get group panel by group uid'
        
        get do 
          group = ::Groups::BaseGroupService.new(params)
          if group.has_member?(current_user)
            ::Groups::GroupSerializer.new(group.projection, { params: { current_user_id: current_user.id } }).serializable_hash
          else 
            status 403
          end
        end
      end
    end
  end
end