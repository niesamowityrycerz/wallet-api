module Api
  module V1
    module Transactions
      module TransactionFilters 
        extend Grape::API::Helpers 

        params :transaction_filters do |_options|
          optional :filters, type: Hash do 
            optional :date_of_transaction, type: Hash do 
              optional :from, type: Date 
              optional :to, type: Date
            end
            optional :amount, type: Hash do 
              optional :max, type: Integer
              optional :min, type: Integer
            end
            optional :status, type: Array
            optional :users, type: Array
            optional :type, type: String 
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
          route_param :transaction_uid do 
            mount Api::V1::Transactions::AcceptTransaction
            mount Api::V1::Transactions::RejectTransaction
            mount Api::V1::Transactions::CheckOutTransaction
            mount Api::V1::Transactions::CorrectTransaction
            mount Api::V1::Transactions::SettleTransaction
            mount Api::V1::Transactions::CloseTransaction
          end 
        end

  

        
      end
    end
  end
end