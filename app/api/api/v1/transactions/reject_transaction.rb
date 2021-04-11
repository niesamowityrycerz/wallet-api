module Api 
  module V1 
    module Transactions
      class RejectTransaction < Base 
        before do 
          authenticate_user!
        end


        desc 'Reject transaction'
        resource :reject do 

          params do 
            requires :reason_for_rejection, type: String
          end

          post do 
            transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])
            if transaction.debtor_id == current_user.id 
              Rails.configuration.command_bus.call(
                ::Transactions::Commands::RejectTransaction.new(params)
              )
              redirect "/api/v1/transactions", permanent: true
            else 
              403 
            end 
          end 
        end

      end
    end
  end
end