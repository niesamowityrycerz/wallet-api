module Api 
  module V1 
    module Debts
      class IssueDebt < Base
        before do 
          authenticate_user!
        end

        desc 'Issue debt'
        resource :new do 

          params do 
            requires :debtor_id, type: Integer
            requires :amount, type: Float
            requires :description, type: String 
            requires :currency_id, type: Integer 
            optional :date_of_transaction, type: Date 
          end

          post do 
            debt_uid = SecureRandom.uuid 
            params.merge!({
              debt_uid: debt_uid,
              creditor_id: current_user.id
            })
            Rails.configuration.command_bus.call(
              ::Debts::Commands::IssueDebt.new(params)
            )
            redirect "/api/v1/debt/#{debt_uid}", permanent: true
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