module ReadModels
  module Groups
    module Handlers 
      class OnInvitationAccepted
        def call(event)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: event.data.fetch(:group_uid))
          group_p.update!({
            members: group_p.members + event.data.fetch(:member_id),
            state: event.data.fetch(:state)
          })

          #WriteModels::GroupMembers.find_by!(group_id: )
        end 
      end
    end
  end
end