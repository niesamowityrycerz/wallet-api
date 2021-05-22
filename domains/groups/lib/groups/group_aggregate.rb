require 'aggregate_root'

module Groups
  class GroupAggregate
    include AggregateRoot

    MemberNotAllowed         = Class.new(StandardError)
    UnpermittedRepaymentDate = Class.new(StandardError)
    OperationNotPermitted    = Class.new(StandardError)
    NotEntitledToCloseGroup  = Class.new(StandardError)

    def initialize(id)
      @id = id 
      @leader = nil 
      @members = []
      @invited_users = []
      @rejected_by = []
      @group_lasting_period = nil 
      @status = nil
      @debt_repayment_valid_till = nil 
      @currency_id = nil 
      @debts_within_group = []
    end

    attr_reader :leader, :members, :debt_repayment_valid_till, :group_lasting_period, :invited_users

    def register(data)
      # TODO - seed does not work 
      #leader = User.find_by!(id: data[:leader_id])
      #data[:invited_users].each do |id|
      #  invited_user = User.find_by!(id: id)
      #  raise MemberNotAllowed.new "#{invited_user.username} is not your friend!" unless leader.friends.include? invited_user
      #end

      apply Events::GroupRegistered.strict({
        group_uid: @id,
        leader_id: data.fetch(:leader_id),
        invited_users: data.fetch(:invited_users),
        from: data.fetch(:from),
        to: data.fetch(:to),
        group_name: data.fetch(:group_name)
      })
    end

    def add_group_terms(data)
      raise UnpermittedRepaymentDate.new 'Unpermitted repayment date!' unless group_lasting_period.repayment_date_valid?(data.fetch(:debt_repayment_valid_till))

      apply Events::GroupSettlementTermsAdded.strict({
        currency_id: data.fetch(:currency_id),
        group_uid: @id,
        debt_repayment_valid_till: data.fetch(:debt_repayment_valid_till),
        status: :terms_added
      })
    end

    def accept_invitation(data)
      raise OperationNotPermitted.new "You were not invited" unless  invited_users.include? data.fetch(:member_id)

      apply Events::InvitationAccepted.strict({
        group_uid: data.fetch(:group_uid),
        member_id: data.fetch(:member_id)
      })
    end

    def reject_invitation(data)
      raise OperationNotPermitted.new "You were not invited" unless  invited_users.include? data.fetch(:user_id)

      apply Events::InvitationRejected.strict({
        group_uid: @id,
        user_id: data.fetch(:user_id)
      })
    end

    def close_group(data)
      raise NotEntitledToCloseGroup.new "You are not entitled to close group" unless leader.id == data.fetch(:leader_id)
      apply Events::GroupClosed.strict({
        group_uid: @id,
        status: :closed
      })
    end

    def invite_user(data)
      raise MemberNotAllowed.new  unless leader.friends.include? User.find_by!(id: data.fetch(:user_id))

      apply Events::UserInvited.strict({
        group_uid: @id,
        invited_user_id: data.fetch(:user_id)
      })
    end

    def leave_group(data)
      raise OperationNotPermitted.new unless members.map(&:id).include? data.fetch(:member_id) 
      apply Events::GroupLeft.strict({
        user_id: data.fetch(:member_id),
        group_uid: @id
      })
       

      if data.fetch(:member_id) == leader.id
        new_leader_id = Calculators::GetNewLeader.set(members)
        if !new_leader_id.nil?
          apply Events::GroupLeaderChanged.strict({
            group_uid: @id,
            new_leader_id: new_leader_id
          })
        end 
      end

    end

    on Events::GroupRegistered do |event|
      @group_lasting_period = Entities::GroupLastingPeriod.new(event.data.fetch(:from), event.data.fetch(:to))
      @stause = :init
      @invited_users = event.data.fetch(:invited_users)
      @leader = User.find_by!(id: event.data.fetch(:leader_id))
      @members << Entities::Member.new(event.data.fetch(:leader_id))
    end

    on Events::GroupSettlementTermsAdded do |event|
      @status = event.data.fetch(:status)
      @debt_repayment_valid_till = event.data.fetch(:debt_repayment_valid_till)
      @currency_id = event.data.fetch(:currency_id)
    end

    on Events::InvitationAccepted do |event|
      @members << Entities::Member.new(event.data.fetch(:member_id))
    end
    
    on Events::InvitationRejected do |event|
      @rejected_by << event.data.fetch(:user_id)
    end

    on Debts::Events::DebtIssued do |event|
      @debts_within_group << Entities::Debt.new(event.data.fetch(:debt_uid))
    end

    on Events::GroupClosed do |event|
      @status = event.data.fetch(:status)
    end

    on Events::UserInvited do |event|
      @invited_users << event.data.fetch(:invited_user_id)
    end

    on Events::GroupLeft do |event|
      @members = @members.select {|member| member.id != event.data.fetch(:user_id) }
    end

    on Events::GroupLeaderChanged do |event|
      @leader = User.find_by!(id: event.data.fetch(:new_leader_id))
    end
  end
end