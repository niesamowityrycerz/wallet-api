class RemoveStatusStateColumnsFromTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :debt_projections, :status, :integer 
    remove_column :debts, :state, :integer
    remove_column :group_projections, :state 
  end
end
