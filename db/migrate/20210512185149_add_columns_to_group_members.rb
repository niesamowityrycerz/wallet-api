class AddColumnsToGroupMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_members, :group_uid, :string
    add_column :group_members, :status, :integer, default: 0
  end
end
