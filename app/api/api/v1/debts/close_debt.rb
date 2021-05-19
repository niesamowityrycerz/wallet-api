module Api 
  module V1
    module Debts 
      class CloseDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Close debt'

        resource :close do 
          patch do 
            debt = ::Debts::CloseDebtsService.new(params)
            if debt.is_creditor? current_user
              debt.close 
              status 200
            else
              error!('You are not entitled to do this!', 403)
            end
          end
        end
      end
    end
  end
end