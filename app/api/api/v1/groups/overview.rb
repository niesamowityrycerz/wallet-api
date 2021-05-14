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
            my_groups = ReadModels::Groups::GroupProjection.joins(group: :group_members).where(group_members: { member_id: current_user.id, invitation_status: :accepted}, groups: { activated: true })
            ::Groups::GroupOverviewSerializer.new(my_groups).serializable_hash 

          end
        end 
      end
    end
  end 
end