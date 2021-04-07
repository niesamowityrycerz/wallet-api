module Api
  module V1
    module Users
      class Base < Api::V1::Base

        resource :users do 
          mount Api::V1::Users::Index
          mount Api::V1::Users::All
        end

      end 
    end
  end
end