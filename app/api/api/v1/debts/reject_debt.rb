module Api 
  module V1 
    module Debts
      class RejectDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Reject debt'
        
        params do 
          requires :reason_for_rejection, type: String, message: 'is missing'
        end

        resource :reject do 
          put do 
            debt = ::Debts::RejectDebtService.new(params)
            if debt.is_debtor? current_user
              debt.reject
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