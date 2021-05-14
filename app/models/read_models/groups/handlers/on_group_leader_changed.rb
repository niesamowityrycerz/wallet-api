module ReadModels
  module Groups 
    module Handlers 
      class OnGroupLeaderChanged 
        def call(event)
          group_uid = event.data.fetch(:group_uid)

          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid)
          group_p.update!({
            leader_id: event.data.fetch(:new_leader_id)
          })
          
        end
      end
    end
  end
end