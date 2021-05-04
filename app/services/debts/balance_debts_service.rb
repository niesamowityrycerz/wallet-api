module Debts 
  class BalanceDebtsService
    # balance debts between 2 users;
    def initialize(credits, debts)
      @credits = credits
      @debts = debts 
    end

    def call
      net_balance = calculate_net_balance(@credits, @debts)
      debts_uids = retrive_debts_uids(@debts)
      net_balance.merge!(debts_uids)
    end

    private 

    def retrive_debts_uids(debts)
      # from WriteModels::Debt -> logic operation based on WriteModels not ReadModels
      binding.pry 
      {
        debts_uids: debts.select("debt_uid").collect{ |debt| debt.debt_uid }
      }

    end

    def calculate_net_balance(credits, debts)
      {
        to_repay: (debts.sum("amount") - credits.sum("amount")).round(2)
      }
    end

    

  end
end