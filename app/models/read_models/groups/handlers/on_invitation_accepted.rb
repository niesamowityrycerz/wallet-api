module ReadModels
  module Groups
    module Handlers 
      class OnInvitationAccepted
        def call(event)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: event.data.fetch(:group_uid))
          group_p.update!({
            members: group_p.members.push(event.data.fetch(:member_id))
          })
          
          group_member = WriteModels::GroupMember.where("group_uid = ? AND member_id = ?", event.data.fetch(:group_uid), event.data.fetch(:member_id))
          group_member.update({
            invitation_status: :accepted
          })

        end 
      end
    end
  end
end