module Api
  module V1 
    module Debts 
      class AcceptDebt < Base

        before do 
          authenticate_user!
        end

        desc 'Accept debt'

        resource :accept do 
          patch do 
            debt = ::Debts::AcceptDebtsService.new(params)
            if debt.is_debtor? current_user
              debt.accept
              status 200
            else 
              error!('You are not entitled to do this!', 403)
            end 
          end
        end 
      end
    end
  end
end