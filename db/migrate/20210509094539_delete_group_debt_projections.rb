class DeleteGroupDebtProjections < ActiveRecord::Migration[5.2]
  def change
    drop_table :group_debt_projections
  end
end
