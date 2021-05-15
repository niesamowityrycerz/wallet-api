module Api 
  module V1 
    module Debts
      class RejectDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Reject debt'
        
        params do 
          requires :reason_for_rejection, type: String
        end

        resource :reject do 
          patch do 
            debt = ::Debts::RejectDebtService.new(params)
            if debt.is_debtor? current_user
              debt.reject
            else 
              403 
            end 
          end 
        end 
      end
    end
  end
end