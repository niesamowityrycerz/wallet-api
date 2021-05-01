module Api
  module V1 
    module Debts 
      class AcceptDebt < Base

        before do 
          authenticate_user!
        end

        # Button
        desc 'Accept debt'
        
        resource :accept do 
          route_param :debt_uid do 
            post do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if debt.debtor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::AcceptDebt.new(params)
                )
                ::DebtSerializer.new(debt, { params: { current_user: current_user } }).serializable_hash
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