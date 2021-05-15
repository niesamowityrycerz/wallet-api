module Groups 
  class AddGroupSettlementTerms 
    def initialize(quantity=30)
      @quantity = quantity
    end

    def call 
      group_uids = get_group_uids(@quantity)
      data = prepare_data(group_uids)
      issue_commands(data)
    end

    private 

    def get_group_uids(q)
      ReadModels::Groups::GroupProjection.pluck(:group_uid).sample(q)
    end

    def prepare_data(group_uids)
      data = []
      group_uids.each do |group_uid|
        data << {
          group_uid: group_uid,
          currency_id: Currency.ids.sample,
          debt_repayment_valid_till: Date.today + rand(1..100)
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