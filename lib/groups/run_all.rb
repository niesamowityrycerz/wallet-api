module Groups 
  class RunAll
    def self.call(groups_q=20, per_group_accept=2, reject_q=10, debts_per_group=2)
      RegisterGroup.new(groups_q).call
      AcceptInvitation.new(per_group_accept).call
      RejectInvitation.new(reject_q).call
      AddGroupSettlementTerms.new.call
      DebtsWithinGroup.new(debts_per_group).call
    end
  end
end