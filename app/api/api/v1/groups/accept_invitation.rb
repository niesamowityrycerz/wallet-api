module Api 
  module V1 
    module Groups
      class AcceptInvitation < Base 

        before do 
          authenticate_user!
        end

        desc 'Accept invitation to group'

        put do 
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: params[:group_uid])
          if group_p.invited_users.include? current_user.id 
            Rails.configuration.command_bus.call(
              ::Groups::Commands::AcceptInvitation.send(params.merge({member_id: current_user.id}))
            )
            status 201
          else 
            error!('Operation not permitted', 403)
          end
        end
      end
    end
  end
end