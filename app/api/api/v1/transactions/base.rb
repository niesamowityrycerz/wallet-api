module Api
  module V1
    module Transactions
      module TransactionFilters 
        extend Grape::API::Helpers 

        params :transaction_filters do |_options|
          optional :filters, type: Hash do 
            optional :date_of_transaction, type: Date 
            optional :amount, type: Hash
            given :amount do 
              requires :max, type: Integer
              requires :min, type: Integer
              all_or_none_of :max, :min 
            end
            optional :status, type: Array, values: %i[pending rejected closed]
            optional :users, type: Array, values: (1..1000)
            optional :type, type: String, values: %w[borrow lend]
            
          end
        end


      end

      class Base < Api::V1::Base

        helpers(
          TransactionFilters
        ) 

        resource :transactions do 
          mount Api::V1::Transactions::All
        end 

        resource :transaction do
          mount Api::V1::Transactions::Index
          mount Api::V1::Transactions::IssueTransaction
          mount Api::V1::Transactions::AcceptTransaction
          mount Api::V1::Transactions::RejectTransaction
          mount Api::V1::Transactions::CheckOutTransaction
          mount Api::V1::Transactions::CorrectTransaction
          mount Api::V1::Transactions::SettleTransaction
          mount Api::V1::Transactions::CloseTransaction
          mount Api::V1::Transactions::FillSettlementTerms
         
        end

  

        
      end
    end
  end
end