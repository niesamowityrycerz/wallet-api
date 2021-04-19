module Users 
  class FriendsSerializer 
    include JSONAPI::Serializer

    attributes :email, :username

  end
end