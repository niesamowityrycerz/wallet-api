class AddInvitedUsersToGroupProjections < ActiveRecord::Migration[5.2]
  def change
    add_column :group_projections, :invited_users, :integer, array: true
  end
end
