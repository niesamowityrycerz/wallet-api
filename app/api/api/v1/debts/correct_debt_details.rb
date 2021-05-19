module Api
  module V1 
    module Debts
      class CorrectDebtDetails < Base 

        before do 
          authenticate_user!
        end

        desc 'Creditor corrects debt details'

        params do 
          optional :amount, type: Float, values: (0.0..1000.0)
          optional :description, type: String, values: ->(val) { val.length < 50}
          optional :currency_id, type: Integer, values: -> { Currency.ids }
          optional :date_of_debt, type: Date, values: (Date.today-30..Date.today)
        end

        resource :correct do 
          patch do 
            debt = ::Debts::CorrectDebtService.new(params, current_user)
            if debt.is_creditor? current_user 
              debt.correct_details
              status 200
            else
              error!('You are not entitled to do this!',403)
            end
          end
        end 
      end
    end
  end
end