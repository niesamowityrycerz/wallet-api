module Groups 
  class PrepareParamsService
    def initialize(params, current_user_id)
      @params = params 
      @current_user_id = current_user_id
    end

    def call
      retrive_repayment_condition(@params)
      prepare_params(@params, @current_user_id)
    end

    private 

    def retrive_repayment_condition(params)
      group_aggregate = ::Debts::Repositories::Group.new.with_group(params[:group_uid])
      @repayment_condition = group_aggregate.debt_repayment_valid_till
    end

    def prepare_params(params, issuer_id)
      base = {
        creditor_id: issuer_id,
        description: params[:description],
        currency_id: params[:currency_id],
        group_uid: params[:group_uid],
        max_date_of_settlement: @repayment_condition
      }
      if params[:credit_equally]
        split_debt_params(base, params[:debtors_ids], params[:amount])
      else
        no_debt_split_params(base, params[:debts_info])
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

  end
end