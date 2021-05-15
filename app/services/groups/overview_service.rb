module Groups 
  class OverviewService 
    def self.groups(current_user)
      ReadModels::Groups::GroupProjection.joins(group: :group_members).where(group_members: { member_id: current_user.id, invitation_status: 'accepted'}, groups: { activated: true })
    end
  end
end