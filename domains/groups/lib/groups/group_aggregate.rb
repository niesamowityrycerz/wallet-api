require 'aggregate_root'

module Groups
  class GroupAggregate
    include AggregateRoot

    MemberNotAllowed = Class.new(StandardError)

    def initialize(id)
      @id = id 
      @leader = nil 
      @members = []
      @invited_users = []
      @from = nil
      @to = nil 
      @state = nil
      @transaction_expired_on = nil 
      @group_transactions = []
    end

    attr_accessor :leader_id, :members, :from, :to, :transaction_expired_on, :group_transactions

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
      apply Events::GroupSettlementTermsAdded.strict({
        currency_id: data.fetch(:currency_id),
        group_uid: @id,
        transaction_expired_on: data.fetch(:transaction_expired_on),
        state: :terms_added
      })
    end

    def accept_invitation(data)
      apply Events::InvitationAccepted.strict({
        group_uid: data.fetch(:group_uid),
        member_id: data.fetch(:member_id),
        state: :invitation_accepted
      })
    end

    def reject_invitation(data)
      apply Events::InvitationRejected.strict({
        group_uid: @id,
        user_id: data.fetch(:user_id),
        state: :invitation_rejected
      })
    end

    def issue_group_transaction(data)
      per_debtor_money = Calculators::CalculateDueMoneyPerMemeber.call(data.fetch(:debtors_ids), data.fetch(:total_amount))

      apply Events::GroupTransactionIssued.strict({
        creditor_id: data.fetch(:creditor_id),
        debtors_ids: data.fetch(:debtors_ids),
        description: data.fetch(:description),
        total_amount: data.fetch(:total_amount),
        per_debtor: per_debtor_money,
        currency_id: @currency_id,
        date_of_transaction: data.fetch(:date_of_transaction) if data.key?(:date_of_transaction),
        group_transaction: true,
        group_uid: @id,
        group_transaction_uid: data.fetch(:group_transaction_uid),
        state: :init
      })
    end

    def close_group_transaction
      # validation here 
      #TODO
    end

    on Events::GroupRegistered do |event|
      @to = event.data.fetch(:to)
      @from = event.data.fetch(:from)
      @state = event.data.fetch(:state)
      @invited_users = event.data.fetch(:invited_users)
    end

    on Events::GroupSettlementTermsAdded do |event|
      @state = event.data.fetch(:state)
      @transaction_expired_on = event.data.fetch(:transaction_expired_on)
    end

    on Events::InvitationAccepted do |event|
      @members << Entities::Member.new(event.data.fetch(:member_id))
      @state = event.data.fetch(:state)
    end

    on Events::InvitationRejected do |event|
      @state = event.data.fetch(:state)
    end

    on Events::GroupTransactionIssued do |event|
      @group_transactions << Entities::GroupTransaction.new(event.data.fetch(:group_transaction_uid))
    end
  end
end