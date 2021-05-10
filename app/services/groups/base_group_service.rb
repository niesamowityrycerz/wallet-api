module Groups 
  class BaseGroupService 
    def initialize(group_uid)
      @group_uid = group_uid 
    end

    def projection
      ReadModels::Groups::GroupProjection.find_by!(group_uid: @group_uid)
    end

    def has_member?(user)
      projection.members.include? user.id || user.admin?
    end
  end
end