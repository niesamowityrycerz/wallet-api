module Groups 
  class RunAll
    def self.call(groups_q=20, accept_q=10, reject_q=10)
      RegisterGroup.new(groups_q).call
      AcceptInvitation.new(accept_q).call
      RejectInvitation.new(reject_q).call
    end
  end
end