module Api 
  module V1
    module Users 
      class AddRepaymentConditions < Base 

        before do 
          authorize_user!
        end

        desc 'User adds repayment conditions'

        params do 
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          requires :maturity_in_days, type: Integer, values: (1..365)
        end

        resource :add_repayment_conditions do 
          post do
            current_user.create!({
              currency_id: params[:currency_id],
              maturity_in_days: params[:maturity_in_days]
            })
            status 201
          end
        end
      end
    end
  end
end