module Api
  module V1
    module Debts
      class Index < Base 
        desc 'Show specific debt'

        before do 
          authenticate_user!
        end

        desc 'Get debt by uid'
        route_param :debt_uid do 
          get do 
            debt = ReadModels::Debts::DebtProjection.find_by!(debt_uid: params[:debt_uid])

            if current_user.admin 
              debt
            elsif debt.creditor_id == current_user.id || debt.debtor_id == current_user.id 
              debt
            else 
              403 
            end
            ::Debts::DebtSerializer.new(debt, { params: { current_user: current_user } }).serializable_hash
          end
        end 
      end 

    end
  end
end