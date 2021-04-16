module Api 
  module V1 
    module Transactions 
      class FillSettlementTerms < Base 
        
        before do 
          authenticate_user!
        end

        #params do 
        #  requires :anticipated_date_of_settlement, type: Date
        #  requires :debtor_settlement_method_id, type: Integer#, values: ::SettlementMethod.all.ids
        #  requires :currency_id, type: Integer, values: ::Currency.all.ids
        #end

        route_param :transaction_uid do 
          resource :fill_settlement_terms do
            post do 
              transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
              if transaction.debtor_id == current_user.id
                params.merge({
                  transaction_uid: params[:transaction_uid],
                  debtor_id: current_user.id
                })

                Rails.configuration.command_bus.call(
                  Transactions::Commands::AddSettlementTerms.new(params)
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