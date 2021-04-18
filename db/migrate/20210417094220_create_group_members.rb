class CreateGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_members do |t|
      t.boolean :founder

      t.timestamps
    end
  end
end
