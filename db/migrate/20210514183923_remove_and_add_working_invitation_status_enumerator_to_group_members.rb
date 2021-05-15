class RemoveAndAddWorkingInvitationStatusEnumeratorToGroupMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :group_members, :invitation_status, :integer
    create_enum :invitation_statuses, %w[waiting accepted rejected]

    add_column :group_members, :invitation_status, :invitation_statuses, default: 'waiting'

  end
end
