module Api 
  module V1
    module Debts 
      class NewRepaymentConditions < Base 

        before do 
          authenticate_user!
        end

        desc 'Overwrite repayment conditions'

        params do 
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          requires :maturity_in_days, type: Integer, values: (0..365)
        end

        resource :new_repayment_conditions do 
          patch do 
            debt = ::Debts::OverwriteRepaymentConditionsService.new(params)
            binding.pry 
            if debt.is_creditor? current_user
              debt.overwrite_repayment_conditions
              status(201)
            else 
              error!('You cannot do that!', 403)
            end
          end
        end
      end
    end
  end
end