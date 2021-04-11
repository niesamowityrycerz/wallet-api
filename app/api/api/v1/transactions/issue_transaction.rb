module Api 
  module V1 
    module Transactions
      class IssueTransaction < Base
        before do 
          authenticate_user!
        end

        desc 'Issue transaction'
        resource :new do 

          params do 
            requires :debtor_id, type: Integer
            requires :amount, type: Float
            requires :description, type: String 
            requires :currency_id, type: Integer 
            optional :date_of_transaction, type: Date 
          end

          post do 
            transaction_uid = SecureRandom.uuid 
            params.merge!({
              transaction_uid: transaction_uid,
              creditor_id: current_user.id
            })
            Rails.configuration.command_bus.call(
              ::Transactions::Commands::IssueTransaction.new(params)
            )
            redirect "/api/v1/transaction/#{transaction_uid}", permanent: true
          end

          # TODO 
          get do 
            binding.pry 
            present 'Here json with form data'
          end

        end
      end
    end
  end
end