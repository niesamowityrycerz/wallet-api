class AddDoubtsToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :doubts, :string, default: nil 
  end
end
