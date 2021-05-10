module Friends 
  class FriendService
    def self.call(current_user)
      current_user.friends + current_user.pending_friends + current_user.requested_friends
    end
  end 
end