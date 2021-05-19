module Api 
  module V1 
    module Debts
      class CheckOutDebtDetails < Base 

        before do 
          authenticate_user!
        end

        desc 'Debtor checks out'

        params do 
          requires :doubts, type: String, message: 'are missing'
        end

        resource :checkout do 
          patch do 
            debt = ::Debts::CheckOutDebtService.new(params)
            if debt.is_debtor? current_user
              debt.check_out
              status 201
            else
              error!('You are not entitled to do this!', 403)
            end
          end   
        end 
      end
    end
  end
end