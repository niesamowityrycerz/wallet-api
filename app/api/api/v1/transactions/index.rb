module Api 
  module V1 
    module Transactions 
      class Index < Api::V1::Transactions::Base 

        #before do 
        #  authorize_user!
        #end

        desc 'Show all user transactions'

        get do 
          if current_user.admin == true 
            transactions = ReadModels::Transactions::TransactionProjection.all
          else 
            transactions = ReadModels::Transactions::TransactionProjection.where(debtor_id: current_user.id, creditor_id: current_user.id)
          end 

          filtered_data = ::TransactionQuery.new(params, transactions).call
          binding.pry 
          ::TransactionSerializer.new(filtered_data)
          binding.pry 
        end

      end
    end
  end
end