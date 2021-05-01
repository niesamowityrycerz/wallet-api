module Api 
  module V1 
    module Debts 
      class FillSettlementTerms < Base 
        
        before do 
          authenticate_user!
        end

        params do 
          requires :anticipated_date_of_settlement, type: Date
          requires :debtor_settlement_method_id, type: Integer#, values: SettlementMethod.all.ids
          requires :currency_id, type: Integer#, values: Currency.all.ids
        end

        route_param :debt_uid do 
          resource :fill_settlement_terms do
            post do 
              debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])
              if debt.debtor_id == current_user.id
                params.merge({
                  debt_uid: params[:debt_uid],
                  debtor_id: current_user.id
                })

                Rails.configuration.command_bus.call(
                  Debts::Commands::AddSettlementTerms.new(params)
                )
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