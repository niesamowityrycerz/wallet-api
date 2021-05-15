module Groups 
  class InvitationToGroupSerializer 
    include JSONAPI::Serializer 

    attribute :invitation_status, :group_uid

    attribute :sent_at do |invitation|
      invitation.created_at.to_date
    end

    link :accept do |invitation|
      "localhost:3000/api/v1/group/#{invitation.group_uid}/accept"
    end

    link :reject do |invitation|
      "localhost:3000/api/v1/group/#{invitation.group_uid}/reject"
    end

    meta do |invitation|
      group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: invitation.group_uid)
      members = group_p.members.collect{ |id| User.find_by!(id: id)}
      {
        group_name: group_p.name,
        members: members.map(&:username),
        from: group_p.from,
        to: group_p.to
      }
    end
  end
end