module ReadModels
  module Groups
    module Handlers 
      class OnUserInvited 
        def call(event)
          group_uid = event.data.fetch(:group_uid)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid)
          group_p.update!({
            invited_users: group_p.invited_users.push(event.data.fetch(:invited_user_id))
          })

          group = WriteModels::Group.find_by!(group_projection_id: group_p.id)
          WriteModels::GroupMember.create!({
            group_id: group.id,
            member_id: event.data.fetch(:invited_user_id) 
          })
        end
      end
    end
  end
end