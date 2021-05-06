module Api
  module V1
    module Users
      class Base < Api::V1::Base

        resource :user do 
          mount Api::V1::Users::Index
          mount Api::V1::Users::Balance
        end

        resource :users do 
          mount Api::V1::Users::DebtorsRanking
          mount Api::V1::Users::CreditorsRanking
          mount Api::V1::Users::All
        end

        mount Api::V1::Users::Me

      end 
    end
  end
end