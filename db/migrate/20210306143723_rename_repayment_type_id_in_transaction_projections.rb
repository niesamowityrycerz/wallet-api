class RenameRepaymentTypeIdInTransactionProjections < ActiveRecord::Migration[5.2]
  def change
    rename_column :transaction_projections, :repayment_type_id, :settlement_method_id

  end
end
