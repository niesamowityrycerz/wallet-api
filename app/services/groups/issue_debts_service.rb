module Groups 
  class IssueDebtsService < BaseGroupService

    def issue_debts
      data = prepare_params(params)
      execute_commands(data)
    end

    private 

    def prepare_params(debt_params)
      base = {
        creditor_id: current_user.id,
        description: debt_params[:description],
        currency_id: debt_params[:currency_id],
        group_uid: group_uid
      }
      if debt_params[:credit_equally]
        split_debt_params(base, debt_params[:debtors_ids], debt_params[:amount])
      else
        no_debt_split_params(base, debt_params[:debts_info])
      end
    end

    def split_debt_params(base, debtors_ids, amount)
      prepared_params = []
      debtors_ids.each do |debtor_id|
        prepared_params << base.merge({
          debtor_id: debtor_id,
          amount: (amount/debtors_ids.count).round(2),
          debt_uid: SecureRandom.uuid
        })
      end
      prepared_params
    end

    def no_debt_split_params(base, debts_info)
      prepared_params = []
      debts_info.each do |debt_info|
        prepared_params << base.merge({
          debt_uid: SecureRandom.uuid,
          debtor_id: debt_info[:debtor_id],
          amount: debt_info[:amount]
        })
      end
      prepared_params
    end

    def execute_commands(debts_data)
      debts_data.each do |debt_data|
        Rails.configuration.command_bus.call(
          Debts::Commands::IssueDebt.send(debt_data)
        )
      end 
    end
  end
end