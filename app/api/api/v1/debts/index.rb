module Api
  module V1
    module Debts
      class Index < Base 

        before do 
          authenticate_user!
        end

        desc 'Get debt by uid'

        get do 
          debt = ::Debts::BaseDebtsService.new(params)
          if debt.has_access? current_user
            debt_projection = debt.debt_projection
            ::Debts::DebtSerializer.new(debt_projection, { params: { current_user: current_user } }).serializable_hash
          else 
            403 
          end
        end
      end 
    end
  end
end