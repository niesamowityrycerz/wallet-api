class RenameColumnFounderToLeaderInGroupMembers < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_members, :founder, :leader
  end
end
