module Api 
  module V1
    module Transactions 
      class CloseTransaction < Base 

        before do 
          authenticate_user!
        end

        desc 'Close transaction'

        route_param :transaction_uid do 
          resource :close do 

            put do 
              transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
              if current_user.admin || transaction.creditor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Transactions::Commands::CloseTransaction.new(params)
                )
                redirect "/api/v1/transaction/#{params[:transaction_uid]}", permanent: true
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