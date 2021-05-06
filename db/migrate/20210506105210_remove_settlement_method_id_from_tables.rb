class RemoveSettlementMethodIdFromTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :debt_projections, :settlement_method_id
    remove_column :repayment_conditions, :settlement_method_id
  end
end
