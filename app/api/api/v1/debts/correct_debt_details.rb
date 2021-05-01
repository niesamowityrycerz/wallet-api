module Api
  module V1 
    module Debts
      class CorrectDebtDetails < Base 

        before do 
          authenticate_user!
        end

        desc 'Creditor corrects debt'

        route_param :debt_uid do 
          resource :correct do 

            params do 
              optional :amount, type: Float 
              optional :description, type: String
              optional :currency_id, type: Integer 
              optional :date_of_debt, type: Date 
            end

            put do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if debt.creditor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::CorrectDebtDetails.new(params)
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