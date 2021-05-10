module Groups 
  class GroupSerializer 
    include JSONAPI::Serializer 

    attribute :debt_repayment_valid_till, :currency, :from, :to, :name 

    attribute :leader do |group|
      User.find_by!(id: group.leader_id).username
    end 

    attribute :members do |group|
      members = group.members 
      members_h = []
      members.each do |member|
        members_h << User.find_by!(id: member).username
      end
      members_h
    end

    meta do |group|
      group_scope_debts = ReadModels::Debts::DebtProjection.where(group_uid: group.group_uid)
      display = {}
      group_scope_debts.each do |debt_p|
        display[debt_p.debt_uid] = {
          creditor: User.find_by!(id: debt_p.creditor_id).username,
          debtor: User.find_by!(id: debt_p.debtor_id).username,
          status: debt_p.status,
          amount: debt_p.amount,
          placed_at: debt_p.created_at,
        }
      end
      display 
    end
  end
end