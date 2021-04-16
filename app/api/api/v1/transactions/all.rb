module Api 
  module V1 
    module Transactions 
      class All < Base 

        before do 
          authenticate_user!
        end

        desc 'Show all user transactions'

        get do 
          if current_user.admin == true 
            transactions = ReadModels::Transactions::TransactionProjection.all
          else 
            transactions = ReadModels::Transactions::TransactionProjection.where("debtor_id = ? OR creditor_id = ?", current_user.id, current_user.id)
          end

          filtered_data = ::TransactionQuery.new(params, params[:pagination], transactions, current_user).call
          x = ::Transactions::AllTransactionsSerializer.new(filtered_data).serializable_hash
          # Is there a better solution?
          x[:data] << { 
            total_accepted: transactions.accepted.count,
            total_closed: transactions.closed.count,
            total_rejected: transactions.rejected
          }
        end

      end
    end
  end
end