class AddReferencesToGroupMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :group_members, :group,  foreign_key: true 
    add_reference :group_members, :member, references: :users, foreign_key: {to_table: :users}
  end
end
