class AddStatusToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :activated, :boolean, default: true
  end
end
