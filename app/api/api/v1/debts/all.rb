module Api 
  module V1 
    module Debts 
      class All < Base 

        before do 
          authenticate_user!
        end

        desc 'Show all user debts'

        get do 
          if current_user.admin
            debts = ReadModels::Debts::DebtProjection.all
          else 
            debts = ReadModels::Debts::DebtProjection.where("debtor_id = ? OR creditor_id = ?", current_user.id, current_user.id)
          end

          filtered_data = ::DebtQuery.new(params, params[:pagination], debts, current_user).call
          ::Debts::AllDebtsSerializer.new(filtered_data).serializable_hash
        end
      end
    end
  end
end