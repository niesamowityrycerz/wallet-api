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

          # TODO
        end
      end
    end
  end
end