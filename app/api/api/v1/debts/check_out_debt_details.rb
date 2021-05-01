module Api 
  module V1 
    module Debts
      class CheckOutDebtDetails < Base 

        before do 
          authenticate_user!
        end

        desc 'Debtor checks out'

        params do 
          requires :doubts, type: String 
        end

        route_param :debt_uid do 
          resource :checkout do 

            post do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if debt.debtor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::CheckOutDebtDetails.new(params)
                )
                redirect "/api/v1/debt/#{params[:debt_uid]}", permanent: true
              else
                403
              end
            end
            
          end 
        end 
      end
    end
  end
end