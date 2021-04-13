module Api
  module V1 
    module Rankings 
      class Base < Api::V1::Base

        resource :ranking do 
          mount Api::V1::Rankings::CreditorsRanking
          mount Api::V1::Rankings::DebtorsRanking
        end
        
      end
    end
  end
end