module Groups 
  class RejectInvitation 
    def initialize(q)
      @q = q
    end

    def call 
      get_groups(@q)
      mapped_data = get_invited_users_per_group(@groups)
      prepare_command(mapped_data)
    end

    private 

    def get_groups(q)
      @groups = ReadModels::Groups::GroupProjection.last(q)
    end

    def get_invited_users_per_group(groups)
      mapper = {}
      groups.each do |group|
        mapper[group.group_uid] = group.invited_users
      end
      mapper
    end

    def prepare_command(users_groups)
      users_groups.each do |group_uid, users|
        users.each do |user_id|
          if user_id.even?
            reject_invitation({ group_uid: group_uid, user_id: user_id })
          end 
        end
      end
    end

    def reject_invitation(data)
      Rails.configuration.command_bus.call(
        Groups::Commands::RejectInvitation.send(data)
      )
    end
  end
end