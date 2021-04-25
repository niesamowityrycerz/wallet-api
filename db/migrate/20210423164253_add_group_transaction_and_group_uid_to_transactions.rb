class AddGroupTransactionAndGroupUidToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_projections, :group_transaction, :boolean
    add_column :transaction_projections, :group_uid, :string
  end
end
