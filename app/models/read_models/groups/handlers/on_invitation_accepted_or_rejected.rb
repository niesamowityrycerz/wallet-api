module ReadModels
  module Groups
    module Handlers 
      class OnInvitationAcceptedOrRejected
        def call(event)
          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: event.data.fetch(:group_uid))
          if event.class.name == "Groups::Events::InvitationAccepted"
            group_p.members << event.data.fetch(:member_id)
          end 
          group_p.state = event.data.fetch(:state)
          group_p.save!

        end
      end
    end
  end
end