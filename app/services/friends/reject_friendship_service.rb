module Friends 
  class RejectFriendshipService
    def initialize(current_user, params)
      @current_user = current_user
      @wanabe_friend = User.find_by!(id: params[:user_id]) 
    end

    def has_friend_request?
      @current_user.requested_friends.include? @wanabe_friend
    end

    def decline_friend 
      @current_user.decline_request(@wanabe_friend)
    end

  end
end