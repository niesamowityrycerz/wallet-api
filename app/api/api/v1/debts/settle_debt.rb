module Api 
  module V1
    module Debts
      class SettleDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Settle debt'
        
        resource :settle do 
          put do 
            debt = ::Debts::SettleDebtsService.new(params)
            if debt.is_debtor? current_user
              debt.settle_debts([params[:debt_uid]])
            else
              403
            end
          end
        end
      end
    end
  end
end