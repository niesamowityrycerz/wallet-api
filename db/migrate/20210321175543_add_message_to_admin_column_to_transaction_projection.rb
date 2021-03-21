class AddMessageToAdminColumnToTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :message_to_admin, :string
  end
end
