module Warnings 
  class RunAll 
    def initialize(warnings_quantity = 10)
      @warnings_q = warnings_quantity
    end

    def call
      Warnings::TransactionExpiredWarning.new()


    end

    private 

    def debtors
      User.all
    end

    def transaction_uids
      ReadModels::Transactions::TransactionProjection.where("status != ?", )

    end


  end
end