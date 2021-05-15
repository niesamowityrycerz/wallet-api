module Groups 
  class GroupSettlementTermsService < BaseGroupService
    def add_group_settlement_terms
      Rails.configuration.command_bus.call(
        ::Groups::Commands::AddGroupSettlementTerms.send(params)
      )
    end
  end
end