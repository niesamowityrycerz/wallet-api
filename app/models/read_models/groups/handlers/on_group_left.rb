module ReadModels
  module Groups 
    module Handlers
      class OnGroupLeft
        def call(event)
          group_uid = event.data.fetch(:group_uid)

          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid)
          group_p.update!({
            members: group_p.members - [event.data.fetch(:user_id)]
          })

          group_member = WriteModels::GroupMember.find_by!("group_uid = ? AND member_id = ?", group_uid, event.data.fetch(:user_id))
          group_member.delete
        end
      end
    end
  end
end