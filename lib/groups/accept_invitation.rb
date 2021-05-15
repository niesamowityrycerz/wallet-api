module Groups 
  class AcceptInvitation 
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
      @groups = ReadModels::Groups::GroupProjection.take(q)
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
            accept_invitation({ group_uid: group_uid, member_id: user_id })
          end 
        end
      end
    end

    def accept_invitation(data)
      Rails.configuration.command_bus.call(
        Groups::Commands::AcceptInvitation.send(data)
      )
    end
  end
end