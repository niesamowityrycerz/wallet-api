class RenameStateColumnInGroups < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_members, :status, :invitation_status
  end
end
