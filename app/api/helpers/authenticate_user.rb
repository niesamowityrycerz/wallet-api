module Helpers 
  module AuthenticateUser 

    def authenticate_user!
      error!('Unauthenticated. Invalid or expired token', 401) if current_user.nil?
      current_user
    end

    def current_user
      @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    
    #def user_signed_in?
    #  binding.pry
    #end

  end 
end
