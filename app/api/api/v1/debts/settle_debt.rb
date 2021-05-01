module Api 
  module V1
    module Debts
      class SettleDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Settle debt'
        
        route_param :debt_uid do 
          resource :settle do 

            put do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if debt.debtor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::SettleDebt.new(params)
                )
                debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
                ::Debts::DebtSerializer.new(debt, { params: { current_user: current_user } }).serializable_hash
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