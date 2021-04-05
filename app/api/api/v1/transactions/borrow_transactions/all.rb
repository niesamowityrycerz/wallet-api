module Api
  module V1 
    module Transactions
      module BorrowTransactions
        class All < Base 
          
          before do 
            authenticate_user!
          end


          desc 'Get all obligations'

          get do 
            ReadModels::Transactions::TransactionProjection.where(debtor_id: current_user.id)

            200 
          end

        end
      end
    end
  end
end