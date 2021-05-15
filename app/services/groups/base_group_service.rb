module Groups 
  class BaseGroupService 
    def initialize(params, current_user=nil)
      @group_uid = params[:group_uid]
      @params = params
      @current_user = current_user
    end

    attr_reader :group_uid, :params, :current_user

    def projection
      ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid)
    end

    def has_member?(user)
      (projection.members.include? user.id) || user.admin?
    end

    def has_invited?(user)
      (projection.invited_users.include? user.id) || user.admin?
    end

    def is_leader?(user)
      (projection.leader_id == user.id) || user.admin?
    end
  end
end