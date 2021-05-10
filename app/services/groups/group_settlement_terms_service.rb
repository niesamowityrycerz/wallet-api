module Groups 
  class GroupSettlementTermsService << BaseGroupService
    def call(terms)
      prepare_command(terms)
    end

    private 

    def prepare_command(data)
      @command = ::Groups::Commands::AddGroupSettlementTerms.send(data)
    end

    attr_reader :command
  end
end