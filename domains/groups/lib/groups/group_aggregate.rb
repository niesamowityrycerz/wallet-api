require 'aggregate_root'

module Groups
  class GroupAggregate
    include AggregateRoot

    MemberNotAllowed                      = Class.new(StandardError)
    GroupDoesNotExist                     = Class.new(StandardError)
    UnpermittedRepaymentDate              = Class.new(StandardError)
    OperationNotPermitted                 = Class.new(StandardError)

    def initialize(id)
      @id = id 
      @leader = nil 
      @members = []
      @invited_users = []
      @group_lasting_period = nil 
      @state = nil
      @debt_repayment_valid_till = nil 
      @currency_id = nil 
    end

    attr_reader :leader_id, :members, :debt_repayment_valid_till, :group_lasting_period, :invited_users

    def register(data)
      # check if invited users are friends with leader
      # raise MemberNotAllowed.new unless
      @leader = User.find_by!(id: data[:leader_id])
      data[:invited_users].each do |id|
        invited_user = User.find_by!(id: id)
        raise MemberNotAllowed.new "User #{invited_user.username} is not allowed" unless @leader.friends.include? invited_user
      end

      apply Events::GroupRegistered.strict({
        group_uid: @id,
        leader_id: data.fetch(:leader_id),
        invited_users: data.fetch(:invited_users),
        from: data.fetch(:from),
        to: data.fetch(:to),
        group_name: data.fetch(:group_name),
        state: :init
      })
    end

    def add_group_terms(data)
      raise GroupDoesNotExist.new "Group with uid #{data.fetch(:group_uid)} does not exist!" unless ReadModels::Groups::GroupProjection.find_by(group_uid: data.fetch(:group_uid))

      raise UnpermittedRepaymentDate.new unless group_lasting_period.repayment_date_valid?(data.fetch(:debt_repayment_valid_till))

      apply Events::GroupSettlementTermsAdded.strict({
        currency_id: data.fetch(:currency_id),
        group_uid: @id,
        debt_repayment_valid_till: data.fetch(:debt_repayment_valid_till),
        state: :terms_added
      })
    end

    def accept_invitation(data)
      raise OperationNotPermitted.new "You were not invited" unless  invited_users.include? data.fetch(:member_id)

      apply Events::InvitationAccepted.strict({
        group_uid: data.fetch(:group_uid),
        member_id: data.fetch(:member_id),
        state: :invitation_accepted
      })
    end

    def reject_invitation(data)
      raise OperationNotPermitted.new "You were not invited" unless  invited_users.include? data.fetch(:user_id)

      apply Events::InvitationRejected.strict({
        group_uid: @id,
        user_id: data.fetch(:user_id),
        state: :invitation_rejected
      })
    end

    def close_group_transaction
      # validation here 
      #TODO
    end

    on Events::GroupRegistered do |event|
      @group_lasting_period = Entities::GroupLastingPeriod.new(event.data.fetch(:from), event.data.fetch(:to))
      @state = event.data.fetch(:state)
      @invited_users = event.data.fetch(:invited_users)
    end

    on Events::GroupSettlementTermsAdded do |event|
      @state = event.data.fetch(:state)
      @debt_repayment_valid_till = event.data.fetch(:debt_repayment_valid_till)
      @currency_id = event.data.fetch(:currency_id)
    end

    on Events::InvitationAccepted do |event|
      @members << Entities::Member.new(event.data.fetch(:member_id))
      @state = event.data.fetch(:state)
    end

    on Events::InvitationRejected do |event|
      @state = event.data.fetch(:state)
    end

  end
end