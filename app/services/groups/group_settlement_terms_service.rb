module Groups 
  class GroupSettlementTermsService < BaseGroupService

    def add_group_terms_command(data)
      adjusted_params = data[:terms].merge({
        group_uid: group_uid
      })
      ::Groups::Commands::AddGroupSettlementTerms.send(adjusted_params)
    end

  end
end