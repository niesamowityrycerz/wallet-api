module Friends 
  class RejectFriendshipService
    def initialize(current_user, params)
      @current_user = current_user
      @params = params 
    end

    private 

    def has_friend_request?
      @current_user.requested_friends.include? @params[:wanabe_friend_id]
    end

    def decline_friend 
      requestor = User.find_by!(id: params[:wanabe_friend_id])
      @current_user.decline_request(requestor)
    end

  end
end