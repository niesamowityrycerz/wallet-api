module Api 
  module V1 
    module Users 
      class All < Api::V1::Users::Base 

        desc 'Get all users'

        get do 
          users = User.all 
          ::Users::BaseProfileSerializer.new(users).serializable_hash
        end
      end
    end
  end
end