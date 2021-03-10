class RemoveInterestColumnFromAllTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :repayment_conditions,    :interest
    remove_column :transaction_projections, :interest
  end
end
