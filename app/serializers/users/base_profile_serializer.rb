module Users 
  class BaseProfileSerializer
    include JSONAPI::Serializer
    
    attributes :username, :email
  end 
end 