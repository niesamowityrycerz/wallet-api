module Debts
  module Handlers 
    class OnCloseDebt
      include CommandHandler

      def call(command)
        debt_uid = command.data[:debt_uid]
        repository = Repositories::Debt.new 
        
        repository.with_debt(debt_uid) do |debt|
          debt.close(command.data)
        end
      end 

    end
  end
end