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

          WriteModels::Group.create!({
            name: event.data.fetch(:group_name),
            from: event.data.fetch(:from),
            to: event.data.fetch(:to)
          })


          #invited_users = event.data.fetch(:invited_users)
          #invited_users.each do |user_id|
          #  WriteModels::GroupInvitation.create!({
          #    user_id: user_id,
          #    group_uids: group_uid
          #  })
          #end 
        end
      end
    end
  end
end