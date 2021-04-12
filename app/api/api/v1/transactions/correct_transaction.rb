module Api
  module V1 
    module Transactions
      class CorrectTransaction < Base 

        before do 
          authenticate_user!
        end

        desc 'Creditor corrects transaction'
        resource :correct do 

          params do 
            optional :amount, type: Float 
            optional :description, type: String
            optional :currency_id, type: Integer 
            optional :date_of_transaction, type: Date 
          end

          put do 
            transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
            if transaction.creditor_id == current_user.id 
              Rails.configuration.command_bus.call(
                ::Transactions::Commands::CorrectTransaction.new(params)
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