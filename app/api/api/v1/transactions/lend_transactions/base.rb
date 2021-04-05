module Api 
  module V1 
    module Transactions
      module LendTransactions 
        class Base < Api::V1::Transactions

          resource :lend_transactions do 
            mount Api::V1::Transactions::LendTransactions::All
          end

        end
      end
    end
  end
end