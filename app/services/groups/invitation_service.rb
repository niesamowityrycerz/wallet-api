module Groups 
  class InvitationService
    def self.invitations(current_user)
      WriteModels::GroupMember.where("member_id = ? AND invitation_status = ?", current_user.id, :waiting)
    end
  end
end