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

          filtered_data = ::TransactionQuery.new(params, transactions, current_user).call
          ::AllTransactionsSerializer.new(filtered_data).serializable_hash
        end

      end
    end
  end
end