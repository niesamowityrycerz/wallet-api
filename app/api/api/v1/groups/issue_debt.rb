module Api 
  module V1 
    module Groups 
      class IssueDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Issue new debt within group scope'

        params do
          requires :description, type: String
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          requires :credit_equally, type: Boolean 

          given credit_equally: ->(val) { val == true } do
            requires :debtors_ids, type: Array[Integer]
            requires :amount, type: Float, values: (0.0...10000.0)
          end

          given credit_equally: ->(val) { val == false } do 
            requires :debts_info, type: Array[JSON] do 
              requires :amount, type: Float, values: (0.0...10000.0)
              requires :debtor_id, type: Integer
            end
          end 
        end

        resource :issue_debt do 
          post do
            group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: params[:group_uid])
            if group_p.members.include? current_user.id
              parameters = ::Groups::PrepareParamsService.new(params, current_user.id).call  
              ::Groups::IssueDebtsWithinGroupScopeService.call(parameters)
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