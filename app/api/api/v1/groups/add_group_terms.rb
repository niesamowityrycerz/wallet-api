module Api 
  module V1 
    module Groups 
      class AddGroupTerms < Base 

        before do 
          authenticate_user!
        end

        desc 'Add group settlement terms'

        params do 
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          requires :debt_repayment_valid_till, type: Date 
        end

        resource :add_terms do 
          patch do
            group = ::Groups::GroupSettlementTermsService.new(params)
            if group.has_member? current_user
              group.add_group_settlement_terms
              status 201
            else
              status 403
            end
          end
        end
      end
    end
  end
end