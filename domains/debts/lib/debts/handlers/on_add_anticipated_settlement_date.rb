module Debts
  module Handlers 
    class OnAddAnticipatedSettlementDate
      include CommandHandler
      
      def call(command)
        debt_uid = command.data[:debt_uid]

        repository = Repositories::Debt.new
        repository.with_debt(debt_uid) do |debt|
          debt.add_anticipated_settlement_date(command.data)
        end
      end
    end
  end
end