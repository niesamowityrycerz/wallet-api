module Api 
  module V1
    module Transactions
      class SettleTransaction < Base 

        before do 
          authenticate_user!
        end

        desc 'Settle transaction'
        resource :settle do 
          post do 
            transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
            if transaction.debtor_id == current_user.id 
              Rails.configuration.command_bus.call(
                ::Transactions::Commands::SettleTransaction.new(params)
              )
              transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
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