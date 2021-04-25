class AddMembersColumnToGroupProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :group_projections, :members, :string
  end
end
