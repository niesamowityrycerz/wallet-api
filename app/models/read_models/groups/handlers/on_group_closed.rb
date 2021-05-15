module ReadModels
  module Groups
    module Handlers 
      class OnGroupClosed 
        def call(event)
          group_uid = event.data.fetch(:group_uid)

          group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid)
          group_p.update!({
            status: event.data.fetch(:status)
          })

          group_p.group.update!({
            activated: false
          })
        end
      end
    end
  end
end