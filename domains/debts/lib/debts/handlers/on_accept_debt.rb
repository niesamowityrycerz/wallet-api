module Debts 
  module Handlers
    class OnAcceptDebt
      include CommandHandler

      def call(command)
        debt_uid = command.data[:debt_uid]
        repository = Repositories::Debt.new
        repository.with_debt(debt_uid) do |debt|
          debt.accept
        end
      end

    end
  end
end