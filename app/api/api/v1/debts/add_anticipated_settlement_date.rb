module Api 
  module V1 
    module Debts 
      class AddAnticipatedSettlementDate < Base 
        
        before do 
          authenticate_user!
        end

        desc 'Debtor adds anticipated settlement dat'

        params do 
          requires :anticipated_date_of_settlement, type: Date, values: ->(val) { Date.today <= val }
        end

        resource :add_anticipated_settlement_date do
          patch do 
            debt = ::Debts::AddAnticipatedSettlementDateService.new(params, current_user)
            if debt.is_debtor? current_user
              debt.set_anticipated_date
              status 200
            end
          end
        end 
      end
    end
  end
end