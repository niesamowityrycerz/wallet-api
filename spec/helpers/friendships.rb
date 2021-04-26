module Friendship 
  def create_friendships(issuer, future_friends)
    future_friends.each do |future_friend|
      issuer.friend_request(future_friend)
      future_friend.accept_request(issuer)
    end
  end
end