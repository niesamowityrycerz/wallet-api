module Groups 
  class AcceptInvitation 
    def initialize(per_group_accept)
      @per_group_accept = per_group_accept
    end

    def call 
      mapped_data = get_invited_users_per_group(get_groups_uids)
      prepare_command(mapped_data)
    end

    private 

    def get_groups_uids
      @groups_uids = ReadModels::Groups::GroupProjection.pluck(:group_uid, :invited_users)
    end

    def get_invited_users_per_group(groups)
      mapper = {}
      groups.each do |group|
        mapper[group.first] = group.second.sample(@per_group_accept)
      end
      mapper
    end

    def prepare_command(users_groups)
      users_groups.each do |group_uid, users|
        users.each do |user_id|
          accept_invitation({ group_uid: group_uid, member_id: user_id })
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