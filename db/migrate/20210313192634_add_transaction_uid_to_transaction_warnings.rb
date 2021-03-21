class AddTransactionUidToTransactionWarnings < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_warnings, :transaction_uid, :string
  end
end
