module Api 
  module V1 
    module Debts
      class IssueDebt < Base

        before do 
          authenticate_user!
        end

        desc 'Issue debt'
        
        params do 
          requires :debtor_id, type: Integer, values: -> { User.ids }
          requires :amount, type: Float, values: ->(val) { va > 0.0 }
          requires :description, type: String 
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          optional :date_of_transaction, type: Date 
        end

        resource :new do 
          post do
            debt = ::Debts::IssueDebtService.new(params, current_user)
            debt.issue
            redirect "/api/v1/debt/#{debt_uid}", permanent: true
          end
        end 
      end
    end
  end
end