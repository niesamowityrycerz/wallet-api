class AddGroupProjectionReferenceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :group_projection, foreign_key: true
  end
end
