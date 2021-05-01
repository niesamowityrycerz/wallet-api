module Api 
  module V1
    module Debts 
      class CloseDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Close debt'

        route_param :debt_uid do 
          resource :close do 

            put do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if current_user.admin || debt.creditor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::CloseDebt.new(params)
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