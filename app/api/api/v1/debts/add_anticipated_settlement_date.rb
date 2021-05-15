module Api 
  module V1 
    module Debts 
      class AddAnticipatedSettlementDate < Base 
        
        before do 
          authenticate_user!
        end

        desc 'Debtor adds anticipated settlement dat'

        params do 
          requires :anticipated_date_of_settlement, type: Date
        end

        resource :add_anticipated_settlement_date do
          patch do 
            debt = ::Debts::AddAnticipatedSettlementDateService.new(params, current_user)
            if debt.id_debtor? current_user
              debt.set_aniticipated_date
            else 
              403
            end 
          end
        end 
      end
    end
  end
end