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
            optional :debtors, type: Array
          end
        end


      end

      class Base < Api::V1::Base

        helpers(
          TransactionFilters
        ) 

        resource :transactions do 
          mount Api::V1::Transactions::Index
        end 

        
      end
    end
  end
end