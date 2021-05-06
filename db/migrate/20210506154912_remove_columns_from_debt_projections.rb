class RemoveColumnsFromDebtProjections < ActiveRecord::Migration[5.2]
  def change
    remove_column :debt_projections, :creditor_informed
    remove_column :debt_projections, :group_debt
  end
end
