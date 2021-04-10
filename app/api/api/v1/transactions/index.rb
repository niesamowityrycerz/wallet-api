module Api
  module V1
    module Transactions
      class Index < Base 
        desc 'Show specific transaction'

        before do 
          authenticate_user!
        end

        route_param :transaction_uid, type: String do 
          get do 
            transaction = ReadModels::Transactions::TransactionProjection.find_by!(transaction_uid: params[:transaction_uid])

            if current_user.admin 
             transaction
            elsif transaction.creditor_id == current_user.id || transaction.debtor_id == current_user.id 
              transaction
            else 
              403 
            end
            ::TransactionSerializer.new(transaction, { params: { current_user: current_user } }).serializable_hash
          end
        end 
      end
    end
  end
end