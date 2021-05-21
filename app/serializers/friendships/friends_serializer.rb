module Friendships
  class FriendsSerializer 
    include JSONAPI::Serializer

    attributes :email, :username

    attribute :status do |object, params|
      if params[:current_user].friends.include? object
        'friends'
      end
    end

    link :accept, if: Proc.new { |object, params|
      params[:current_user].requested_friends.include? object
    } do |user|
      "/api/v1/friend/#{user.id}/accept"
    end

    link :reject, if: Proc.new { |object, params|
      params[:current_user].requested_friends.include? object
    } do |user|
      "/api/v1/friend/#{user.id}/reject"
    end


    link :delete, if: Proc.new { |object, params|
      params[:current_user].friends.include? object
    } do |user|
      "/api/v1/friend/#{user.id}/delete"
    end
  end
end