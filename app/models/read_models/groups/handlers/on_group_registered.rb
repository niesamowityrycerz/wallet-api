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
            members: Array.new([event.data.fetch(:leader_id)]), #workaround, due to sqlite3 constraints  
            invited_users: event.data.fetch(:invited_users),
            leader_id: event.data.fetch(:leader_id),
            state: event.data.fetch(:state)
          })

          # Can I use callbacks(hooks) here?

          group = WriteModels::Group.create!({
            name: event.data.fetch(:group_name),
            from: event.data.fetch(:from),
            to: event.data.fetch(:to),
            group_projection_id: group_p.id
          })

          invited_users = event.data.fetch(:invited_users)
          invited_users << event.data.fetch(:leader_id)
          invited_users.each do |user_id|
            base_data = {
              member_id: user_id,
              group_id: group.id,
              group_uid: group_uid
            }

            if user_id == event.data.fetch(:invited_users)
              WriteModels::GroupMember.create!(base_data.merge({
                founder: true,
                invitation_status: accepted
              }))
            else 
              WriteModels::GroupMember.create!(base_data)
            end 
          end 
        end
      end
    end
  end
end