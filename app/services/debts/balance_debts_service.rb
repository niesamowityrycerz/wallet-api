module Debts 
  class BalanceDebtsService
    def initialize(current_user, user_id)
      @current_user_id = current_user.id
      @user_id = user_id
    end

    def call
      get_accepted_debts(@current_user_id, @user_id)
      get_accepted_credits(@current_user_id, @user_id)
      recognize_balance(@credits, @debts)
    end

    private

    def get_accepted_debts(current_user_id, user_id)
      @debts = WriteModels::Debt.where(creditor_id: user_id, debtor_id: current_user_id).accepted.select("amount","debt_uid")
    end 

    def get_accepted_credits(current_user_id, user_id)
      @credits = WriteModels::Debt.where(creditor_id: current_user_id, debtor_id: user_id).accepted.select("amount","debt_uid")
    end

    def retrive_debts_uids(debts) 
      debts.select("debt_uid").collect{ |debt| debt.debt_uid }
    end

    def recognize_balance(credits, debts)
      net_balance = (debts.sum("amount") - credits.sum("amount")).round(2)
      net_balance > 0 ? retrive_debts_uids(debts) : []
    end

  end
end