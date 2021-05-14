module ReadModels
  module Groups
    module Handlers 
      class OnGroupClosed 
        def call(event)
          group_uid = event.data.fetch(:group_uid)

          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid)
          group_p.update!({
            state: event.data.fetch(:state)
          })

          group = WriteModels::Group.find_by!(group_projection_id: group_p.id)
          group.update!({
            activated: false
          })
        end
      end
    end
  end
end