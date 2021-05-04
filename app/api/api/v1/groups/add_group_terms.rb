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
          post do 
            group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: params[:group_uid]) 
            if group_p.members.include? current_user.id
              Rails.configuration.command_bus.call(
                ::Groups::Commands::AddGroupSettlementTerms.send(params)
              )
              status 201
            else
              error!('You cannot access this group!', 403)
            end
          end
        end


      end
    end
  end
end