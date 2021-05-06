module Groups 
  class IssueDebtsWithinGroupScopeService
   
    def self.call(params)
      issue_debts(params)
    end

    private 

    def self.issue_debts(data)
      data.each do |debt_data|
        Rails.configuration.command_bus.call(
          Debts::Commands::IssueDebt.send(debt_data)
        )
      end 
    end
  end
end