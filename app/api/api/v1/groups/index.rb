module Api 
  module V1 
    module Groups 
      class Index < Base 

        before do 
          authenticate_user!
        end

        desc 'Get group by group uid'
        
        get do 
          # Can I make some validations based on read model?Here: restrict access to group information 
          group = ReadModels::Groups::GroupProjection.find_by!(group_uid: params[:group_uid])
          if group.members.include? current_user.id || current_user.admin?
            ::Groups::GroupSerializer.new(group).serializable_hash
          else 
            error!('You cannot access this group!', 403)
          end
        end
      end
    end
  end
end