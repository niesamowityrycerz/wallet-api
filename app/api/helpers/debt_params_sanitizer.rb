module Helpers 
  module DebtParamsSanitizer
    extend Grape::API::Helpers

    def prepare_params(params, issuer_id)
      base = {
        creditor_id: issuer_id,
        description: params[:description],
        currency_id: params[:currency_id],
        group_uid: params[:group_uid]
      }
      if params[:credit_equally]
        split_equaly_params(base, params[:debtors_ids], params[:amount])
      else
        individual_params(base, params[:debts_info])
      end
    end

    def split_equaly_params(base, debtors_ids, amount)
      sanitized_params = []
      debtors_ids.each do |debtor_id|
        sanitized_params << base.merge({
          debtor_id: debtor_id,
          amount: amount,
          debt_uid: SecureRandom.uuid
        })
      end
      sanitized_params
    end

    def individual_params(base, debts_info)
      sanitized_params = []
      debts_info.each do |debt_info|
        sanitized_params << base.merge({
          debt_uid: SecureRandom.uuid,
          debtor_id: debt_info[:debtor_id],
          amount: debt_info[:amount]
        })
      end
      sanitized_params
    end

  end
end