module ReadModels
  module Groups
    module Handlers 
      class OnInvitationRejected
        def call(event)
          group_member = WriteModels::GroupMember.where("group_uid = ? AND member_id = ?", event.data.fetch(:group_uid), event.data.fetch(:user_id))
          group_member.update({
            invitation_status: :rejected
          })
        end
      end
    end
  end
end