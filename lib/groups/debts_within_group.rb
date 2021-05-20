module Groups
  class DebtsWithinGroup 
    def initialize(debts_per_group)
      @debts_per_group = debts_per_group
      @groups_uids = ReadModels::Groups::GroupProjection.pluck(:group_uid)
    end

    def call 
      @debts_per_group.times do 
        @groups_uids.each do |group_uid|
          pick_the_creditor(group_uid)
          debtors = pick_debtors(group_uid)
          debts_info = prepare_debts_details(debtors)
          issue_debts(debts_info, group_uid)
        end 
      end
    end

    private 

    def pick_the_creditor(uid)
      @creditor_id = ReadModels::Groups::GroupProjection.find_by!(group_uid: uid).members.sample
    end

    def pick_debtors(group_uid)
      group_members = ReadModels::Groups::GroupProjection.find_by!(group_uid: group_uid).members
      group_members = group_members.select { |member_id| member_id != @creditor_id }
      if @creditor_id.even?
        group_members.sample(group_members.count - 1 <= 0 ? group_members.count : 2)
      else 
        group_members
      end
    end

    def prepare_debts_details(debtors)
      debts_info = []
      debtors.each do |debtor_id|
        debts_info << {
          amount: rand(10.0..100.0).round(2),
          debtor_id: debtor_id
        }
      end
      debts_info
    end

    def issue_debts(debts_info, group_uid)
      debts_info.each do |info|
        Rails.configuration.command_bus.call(
          Debts::Commands::IssueDebt.send({
            debt_uid: SecureRandom.uuid,
            creditor_id: @creditor_id,
            debtor_id: info[:debtor_id],
            amount: info[:amount],
            description: 'test',
            currency_id: Currency.first.id,
            group_uid: group_uid
          })
        )
      end 
    end
  end
end