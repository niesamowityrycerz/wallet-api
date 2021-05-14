module Api 
  module V1 
    module Groups 
      class AddGroupTerms < Base 

        before do 
          authenticate_user!
        end

        desc 'Add group settlement terms'

        params do 
          requires :terms, type: Hash do 
            requires :currency_id, type: Integer, values: -> { Currency.ids }
            requires :debt_repayment_valid_till, type: Date 
          end 
        end

        resource :add_terms do 
          patch do
            group = ::Groups::GroupSettlementTermsService.new(params[:group_uid])
            if group.has_member? current_user
              Rails.configuration.command_bus.call(group.add_group_terms_command(params)) # maybe, just call something like group.add_group_settlement_terms 
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