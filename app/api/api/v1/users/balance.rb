module Api 
  module V1 
    module Users 
      class Balance < Base 

        before do 
          authenticate_user!
        end 
        
          
        desc 'Balance debts between two users'
          
        resource :balance do 
          patch do 
            debts_uids = ::Debts::BalanceDebtsService.new(current_user, params[:id]).call
            if debts_uids.any?
              ::Debts::SettleDebtsService.settle_debts(debts_uids)
              status 201
            else 
              error!('Unable to proceed!', 404)
            end
          end
        end
      end
    end
  end
end