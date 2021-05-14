class AddMembersColumnToGroupProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :group_projections, :members, :integer, array: true
  end
end
