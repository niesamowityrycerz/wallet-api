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
          requires :amount, type: Float, values: (0.0..1000.0), message: 'is missing'
          requires :description, type: String, values: ->(val) { val.length < 50 },  message: 'is missing'
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          optional :date_of_transaction, type: Date, values: ((Date.today-30)..Date.today)
        end

        resource :new do 
          post do
            debt = ::Debts::IssueDebtService.new(params, current_user)
            debt.issue
            redirect "/api/v1/debt/#{debt.params["debt_uid"]}", permanent: true
          end
        end 
      end
    end
  end
end