module Api 
  module V1 
    module Users 
      class Balance < Base 

        before do 
          authenticate_user!
        end 
        
          
        desc 'Balance debts between two users'
  
        route_param :user_id do 
          resource :balance do 
            post do 
              debts_uids = ::Debts::BalanceDebtsService.new(current_user, params[:user_id])
              if debts_uids.any?
                ::Debts::SettleDebtsService.call(debts_uids)
              else 
               status 403 
              end
            end
          end
        end

      end
    end
  end
end