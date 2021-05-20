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

    link :add_group_terms do |group|
      "localhost:3000/api/v1/group/#{group.group_uid}/add_terms"
    end

    link :add_member do |group|
      "localhost:3000/api/v1/group/#{group.group_uid}/add_member"
    end

    link :close_group, if: Proc.new { |group, params|
      group.leader_id == params[:current_user_id]
    } do |group_object|
      "localhost:3000/api/v1/#{group_object.group_uid}/close_group"
    end

    link :leave_group do |group|
      "localhost:3000/api/v1/group/#{group.group_uid}/leave"
    end

    meta do |group|
      group_scope_debts = ReadModels::Debts::DebtProjection.where(group_uid: group.group_uid)
      display = { debts: [] }
      group_scope_debts.each do |debt_p|
        display[:debts] << {
          creditor: User.find_by!(id: debt_p.creditor_id).username,
          debtor: User.find_by!(id: debt_p.debtor_id).username,
          status: debt_p.status,
          amount: debt_p.amount,
          placed_at: debt_p.created_at.to_date,
        }
      end
      display 
    end
  end
end