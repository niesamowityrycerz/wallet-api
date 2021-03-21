class AddAdminInformedColumndToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :admin_informed, :boolean, default: false 
  end
end
