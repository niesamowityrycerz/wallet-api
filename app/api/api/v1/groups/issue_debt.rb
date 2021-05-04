module Api 
  module V1 
    module Groups 
      class IssueDebt < Base 

        before do 
          authenticate_user!
        end

        desc 'Add new split debt within group scope'

        params do
          requires :description, type: String
          requires :currency_id, type: Integer, values: -> { Currency.ids }
          requires :credit_equally, type: Boolean 

          given credit_equally: ->(val) { val == true } do
            requires :debtors_ids, type: Array[Integer]
            requires :amount, type: Float, values: (0.0...10000.0)
          end

          given credit_equally: ->(val) { val == false } do 
            requires :debts_info, type: Array do 
              requires :amount, type: Float, values: (0.0...10000.0)
              requires :debtor_id, type: Integer
            end
          end 
        end

        resource :add_debt do 
          post do

            group_p = ReadModels::Groups::GroupProjection.find_by!(group_uid: params[:group_uid])
            if group_p.members.include? current_user.id
              command_data = prepare_params(params, current_user.id)

              test = ::Debts::Repositories::Group.new.with_group(params[:group_uid])
              command_data.each do |command|
                command[:max_date_of_settlement] = test.debt_repayment_valid_till
              end

              command_data.each do |data|
                Rails.configuration.command_bus.call(
                  ::Debts::Commands::IssueDebt.send(data)
                )
              end
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