module Api 
  module V1 
    module Users 
      class Balance < Base 

        before do 
          authenticate_user!
        end 
        
          
        desc 'Balance debts between two users'
          
        resource :balance do 
          post do 
            debts_uids = ::Debts::BalanceDebtsService.new(current_user, params[:id])
            if debts_uids.any?
              ::Debts::SettleDebtsService.settle_debts(debts_uids)
            else 
              status 403 
            end
          end
        end
      end
    end
  end
end