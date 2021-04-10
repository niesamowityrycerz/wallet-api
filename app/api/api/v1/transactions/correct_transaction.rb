module Api
  module V1 
    module Transactions
      class CorrectTransaction < Base 

        before do 
          authenticate_user!
        end

        desc 'Creditor corrects transaction'

        route_param :transaction_uid do 
          resource :correct do 

            params do 
              optional :amount, type: Float 
              optional :description, type: String
              optional :currency_id, type: Integer 
              optional :date_of_transaction, type: Date 
            end

            post do 
              transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
              if transaction.creditor_id == current_user.id 
                Rails.configuration.command_bus.call(
                  ::Transactions::Commands::CorrectTransaction.new(params)
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