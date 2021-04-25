module ReadModels
  module Groups
    module Handlers 
      class OnGroupRegistered
        def call(event)
          group_uid = event.data.fetch(:group_uid)

          group_p = ReadModels::Groups::GroupProjection.create!({
            group_uid: group_uid,
            name: event.data.fetch(:group_name),
            from: event.data.fetch(:from),
            to: event.data.fetch(:to),
            invited_users: event.data.fetch(:invited_users),
            leader_id: event.data.fetch(:leader_id),
            state: event.data.fetch(:state)
          })
        end
      end
    end
  end
end