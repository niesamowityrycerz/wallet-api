module Api
  module V1
    module Users
      class Base < Api::V1::Base

        resource :user do 
          route_param :id do 
            mount Api::V1::Users::Index
            mount Api::V1::Users::Balance
            mount Api::V1::Users::AddRepaymentConditions
          end 
        end

        resource :users do 
          mount Api::V1::Users::All
        end

        mount Api::V1::Users::Me
      end 
    end
  end
end