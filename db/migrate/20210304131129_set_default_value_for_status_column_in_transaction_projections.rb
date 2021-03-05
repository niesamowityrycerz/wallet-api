class SetDefaultValueForStatusColumnInTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    change_column :transaction_projections, :status, :integer, default: 0 
  end
end
