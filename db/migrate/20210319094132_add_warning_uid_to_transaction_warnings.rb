class AddWarningUidToTransactionWarnings < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_warnings, :penalty_points, :float 
    add_column :transaction_warnings, :warning_uid, :string 
  end
end
