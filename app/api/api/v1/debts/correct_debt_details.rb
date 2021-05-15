module Api
  module V1 
    module Debts
      class CorrectDebtDetails < Base 

        before do 
          authenticate_user!
        end

        desc 'Creditor corrects debt details'

        params do 
          optional :amount, type: Float, values: ->(val) { val > 0.0 }
          optional :description, type: String
          optional :currency_id, type: Integer, values: -> { Currency.ids }
          optional :date_of_debt, type: Date 
        end

        resource :correct do 
          put do 
            debt = ::Debts::CorrectDebtDetails.new(params)
            if debt.is_creditor? current_user 
              deb.correct_details
            else
              403
            end
          end
        end 
      end
    end
  end
end