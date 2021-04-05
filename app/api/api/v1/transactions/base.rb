module Api
  module V1
    module Transactions
      class Base < Api::V1::Base
              
        mount Api::V1::Transactions::LendTransactions::Base
        mount Api::V1::Transactions::BorrowTransactions::Base 

      end
    end
  end
end