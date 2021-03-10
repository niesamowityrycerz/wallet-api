class AddCreditorInformedToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :creditor_informed, :boolean, default: false
  end
end
