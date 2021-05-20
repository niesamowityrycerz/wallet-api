module Groups 
  class AddGroupSettlementTerms 
    def initialize
      @group_uids = ReadModels::Groups::GroupProjection.pluck(:group_uid, :to)
    end

    def call 
      data = prepare_data(@group_uids)
      issue_commands(data)
    end

    private 

    def prepare_data(group_uids)
      data = []
      group_uids.each do |group_uid|
        data << {
          group_uid: group_uid[0],
          currency_id: Currency.ids.sample,
          debt_repayment_valid_till: rand(group_uid[1]..group_uid[1]+10)
        }
      end
      data
    end

    def issue_commands(commands_data)
      commands_data.each do |command_data|
        Rails.configuration.command_bus.call(
          Groups::Commands::AddGroupSettlementTerms.send(command_data)
        )
      end
    end

  end
end