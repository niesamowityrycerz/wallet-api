module Api 
  module V1 
    module Transactions
      module LendTransactions
        class All < Base 
          
          before do 
            authenticate_user!
          end

          desc 'Get all recivables' 

          get do 
            ReadModels::Transactions::TransactionProjection.where(creditor_id: current_user.id)
          end

        end
      end
    end
  end
end