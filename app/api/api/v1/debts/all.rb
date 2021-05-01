module Api 
  module V1 
    module Debts 
      class All < Base 

        before do 
          authenticate_user!
        end

        desc 'Show all user debts'

        get do 
          if current_user.admin == true 
            debts = ReadModels::Debts::DebtProjection.all
          else 
            debts = ReadModels::Debts::DebtProjection.where("debtor_id = ? OR creditor_id = ?", current_user.id, current_user.id)
          end

          filtered_data = ::DebtQuery.new(params, params[:pagination], debts, current_user).call
          x = ::Debts::AllDebtsSerializer.new(filtered_data).serializable_hash
          # Is there a better solution?
          x[:data] << { 
            total_accepted: debts.accepted.count,
            total_closed: debts.closed.count,
            total_rejected: debts.rejected
          }
        end

      end
    end
  end
end