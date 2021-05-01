module Api 
  module V1 
    module Debts
      class RejectDebt < Base 
        before do 
          authenticate_user!
        end


        desc 'Reject debt'
        
        route_param :debt_uid do 
          resource :reject do 

            params do 
              requires :reason_for_rejection, type: String
            end

            put do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if debt.debtor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::RejectDebt.new(params)
                )
                redirect "/api/v1/debts", permanent: true
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