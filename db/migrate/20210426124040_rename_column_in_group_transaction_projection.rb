class RenameColumnInGroupTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_transaction_projections, :due_money_per_debtor, :due_money_per_reciever
  end
end
