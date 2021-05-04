module Api
  module V1
    module Users
      class Base < Api::V1::Base

        resource :me do 
          mount Api::V1::Users::Index
        end

        resource :users do 
          mount Api::V1::Users::DebtorsRanking
          mount Api::V1::Users::CreditorsRanking
          mount Api::V1::Users::All
          mount Api::V1::Users::Balance
        end

      end 
    end
  end
end