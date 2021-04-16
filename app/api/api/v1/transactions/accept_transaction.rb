module Api
  module V1 
    module Transactions 
      class AcceptTransaction < Base

        before do 
          authenticate_user!
        end

        # Button
        desc 'Accept transaction'
        
        resource :accept do 
          route_param :transaction_uid do 
            post do 
              transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
              if transaction.debtor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Transactions::Commands::AcceptTransaction.new(params)
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