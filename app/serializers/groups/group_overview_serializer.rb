module Groups
  class GroupOverviewSerializer 
    include JSONAPI::Serializer 

    attributes :name, :created_at

    attribute :members do |group|
      members = group.members 
      members_h = []
      members.each do |member|
        members_h << User.find_by!(id: member).username
      end
      members_h
    end

    link :group_panel do |group|
      "localhost:3000/api/v1/group/#{group.group_uid}"
    end

    link :leave_group do |group|
      "localhost:3000/api/v1/group/#{group.group_uid}/leave"
    end

    link :close_group, if: Proc.new { |group, current_user_id| 
      current_user_id == group.leader_id
    } do |object|
      "localhost:3000/api/v1/group/#{group.group_uid}/close"
    end


  end
end