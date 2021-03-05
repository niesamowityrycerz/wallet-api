class AddStatusColumnToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :status, :integer
  end
end
