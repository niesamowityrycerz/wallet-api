module ReadModels
  module Groups
    module Handlers 
      class OnInvitationRejected
        def call(event)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: event.data.fetch(:group_uid))
          group_p.update!({
            state: event.data.fetch(:state)
          })

        end
      end
    end
  end
end