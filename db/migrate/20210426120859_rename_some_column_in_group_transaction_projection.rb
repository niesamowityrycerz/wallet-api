class RenameSomeColumnInGroupTransactionProjection < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_transaction_projections, :creditor_id, :issuer_id
    rename_column :group_transaction_projections, :debtors_ids, :recievers_ids 
  end
end
