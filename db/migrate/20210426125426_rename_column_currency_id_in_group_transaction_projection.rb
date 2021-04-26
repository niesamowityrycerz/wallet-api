class RenameColumnCurrencyIdInGroupTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_transaction_projections, :currency_id, :currency 
  end
end
