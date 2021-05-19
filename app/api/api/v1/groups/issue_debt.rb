module Api 
  module V1 
    module Groups 
      class IssueDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Issue new debt within group scope'

        params do
          requires :description, type: String, message: 'is missing'
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          requires :credit_equally, type: Boolean 

          given credit_equally: ->(val) { val == true } do
            requires :debtors_ids, type: Array[Integer], values: -> { User.ids }
            requires :amount, type: Float, values: (0.0...10000.0)
          end

          given credit_equally: ->(val) { val == false } do 
            requires :debts_info, type: Array[JSON] do 
              requires :amount, type: Float, values: (0.0...10000.0)
              requires :debtor_id, type: Integer, values: -> { User.ids }
            end
          end 
        end

        resource :issue_debt do 
          post do
            group = ::Groups::IssueDebtsService.new(params, current_user)
            if group.has_member? current_user
              group.issue_debts
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