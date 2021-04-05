module Api
  module V1
    module Transactions
      module BorrowTransactions
        class Base < Api::V1::Transactions

          resource :borrow_transactions do 
            mount Api::V1::Transactions::BorrowTransactions::All
          end
          
        end
      end
    end
  end
end