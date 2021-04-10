module Api 
  module V1 
    module Transactions
      class CheckOutTransaction < Base 

        before do 
          authenticate_user!
        end

        desc 'Debtor checks out'

        route_param :transaction_uid do 
          resource :checkout do 

            params do 
              requires :doubts, type: String 
            end

            post do 
              transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
              if transaction.debtor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Transactions::Commands::CheckOutTransaction.new(params)
                )
                ::TransactionSerializer.new(transaction, { params: { current_user: current_user } }).serializable_hash
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