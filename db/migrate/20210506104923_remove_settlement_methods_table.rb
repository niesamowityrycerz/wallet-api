class RemoveSettlementMethodsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :settlement_methods
  end
end
