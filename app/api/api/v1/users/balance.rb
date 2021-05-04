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
              # use write models beacuse this is a buisness logic validation -> tis operation has serious consequences
              current_user_credits = WriteModels::Debt.accepted.where(creditor_id:  current_user.id, debtor_id: params[:user].id)
              current_user_debts =   WriteModels::Debt.accepted.where(creditor_id:  user.id, debtor_id: current_user.id)

              # excesive coupling?
              # check net balance 
              if current_user_credits.sum("amount") < current_user_debts.sum("amount")
                x = ::Services::Debts::BalanceDebtsService.new(current_user_credits, current_user_debts)
              else
                 error!('Operation not permitted', 403)
              end 
            end
          end
        end
      end
    end
  end
end